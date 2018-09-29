defmodule RockBot.AmqpProcessorTest do
  use ExUnit.Case

  doctest RockBot.AmqpProcessor

  def setup %{} do
    {:ok, server_pid} = RockBot.AmqpProcessor.start_link([])
    {:ok, server: server_pid}
  end
end
