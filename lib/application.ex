defmodule RockBot.Application do
  use Application

  def start(_type, _args) do
    children = [
      {RockBot.AmqpProcessor, name: MessageProcessor},
      RockBot.ChatPoller
    ]
    opts = [strategy: :one_for_one, name: RockBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
