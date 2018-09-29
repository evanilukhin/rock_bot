defmodule RockBot.AmqpProcessor do
  alias RockBot.Config
  require Logger

  use GenServer
  use AMQP

  def start_link(opts) do
    GenServer.start_link(__MODULE__, [], opts)
  end

  @bot_exchange  "rock_bot_exchange"
  @bot_queue     "rock_bot_queue"
  @web_exchange  "rock_web_exchange"
  @web_queue     "rock_web_queue"

  def init(opts) do
    connection_url = Config.AMQP.rabbitmq_connection_url()
    case Connection.open(connection_url) do
      {:ok, conn}  ->
        {:ok, chan} = Channel.open(conn)
        setup_queue(chan)
        :ok = Basic.qos(chan, prefetch_count: 10)
        {:ok, _consumer_tag} = Basic.consume(chan, @web_queue)
        {:ok, chan}
      {:error, :econnrefused} ->
        Logger.warn("RabbitMQ with connection_url: \"#{connection_url}\" is not working. Waiting the service.")
        Config.AMQP.restart_timeout() |> :timer.sleep
        __MODULE__.init(opts)
      result -> Logger.error("Unexpected result: #{result}")
    end
  end

  # Confirmation sent by the broker after registering this process as a consumer
  def handle_info({:basic_consume_ok, %{consumer_tag: _consumer_tag}}, chan) do
    {:noreply, chan}
  end

  # Sent by the broker when the consumer is unexpectedly cancelled (such as after a queue deletion)
  def handle_info({:basic_cancel, %{consumer_tag: _consumer_tag}}, chan) do
    {:stop, :normal, chan}
  end

  # Confirmation sent by the broker to the consumer process after a Basic.cancel
  def handle_info({:basic_cancel_ok, %{consumer_tag: _consumer_tag}}, chan) do
    {:noreply, chan}
  end

  def handle_info({:basic_deliver, payload, %{delivery_tag: tag, redelivered: redelivered}}, chan) do
    spawn fn -> consume(chan, tag, redelivered, payload) end
    {:noreply, chan}
  end

  def handle_cast({:send_message, message}, chan) do
    Basic.publish(chan, @bot_exchange, @bot_queue, message)
    {:noreply, chan}
  end

  defp setup_queue(chan) do
    {:ok, _} = Queue.declare(chan, @bot_queue, durable: true)
    {:ok, _} = Queue.declare(chan, @web_queue, durable: true)
    :ok = Exchange.fanout(chan, @bot_exchange, durable: true)
    :ok = Exchange.fanout(chan, @web_exchange, durable: true)
    :ok = Queue.bind(chan, @bot_queue, @bot_exchange)
    :ok = Queue.bind(chan, @web_queue, @web_exchange)
  end

  defp consume(channel, tag, _redelivered, payload) do
    case RockBot.send_message(payload) do
      :ok ->
        Basic.ack channel, tag
      _ ->
        Logger.error("Message #{payload} was not proceed")  
    end
  end
end
