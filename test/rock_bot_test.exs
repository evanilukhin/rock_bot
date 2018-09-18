defmodule RockBotTest do
  use ExUnit.Case
  doctest RockBot

  test "greets the world" do
    assert RockBot.hello() == :world
  end
end
