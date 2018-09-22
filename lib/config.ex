defmodule RockBot.Config do
  defmodule AMQP do
    def host do
      Application.get_env(:amqp, :host)
    end

    def port do
      Application.get_env(:amqp, :port)
    end

    def username do
      Application.get_env(:amqp, :username)
    end

    def password do
      Application.get_env(:amqp, :password)
    end
  end
end
