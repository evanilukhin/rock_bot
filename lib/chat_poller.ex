defmodule RockBot.ChatPoller do
  use GenServer
  require Logger

  def start_link(_) do
    GenServer.start_link __MODULE__, :ok, name: __MODULE__
  end

  def init(:ok) do
    update()
    {:ok, 0}
  end

  def handle_cast(:update, offset) do
    new_offset = Nadia.get_updates([offset: offset]) |> process_messages

    {:noreply, new_offset + 1, 100}
  end

  def handle_info(:timeout, offset) do
    update()
    {:noreply, offset}
  end

  def update do
    GenServer.cast __MODULE__, :update
  end

  defp process_messages({:ok, []}), do: -1

  defp process_messages({:ok, results}) do
    results
    |> Enum.map(fn %{update_id: id} = message ->
      process_message(message)
      id
    end)
    |> List.last
  end

  defp process_messages({:error, %Nadia.Model.Error{reason: reason}}) do
    Logger.log :error, reason
    -1
  end

  defp process_messages({:error, error}) do
    Logger.log :error, error
    -1
  end

  defp process_message(nil), do: IO.puts "nil"

  defp process_message(message) do
    case message do
      %Nadia.Model.Update{
        channel_post: %Nadia.Model.Message{
          chat: %Nadia.Model.Chat{
              title: "chat_through_evanilukhin_rock_bot"
          },
          text: mess
        }
      } when not is_nil(mess) -> GenServer.cast(MessageProcessor, {:send_message,  mess})
      _ -> IO.puts "None"
    end
  end
end
