defmodule RockBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :rock_bot,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {RockBot.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nadia, "~> 0.4.4"},
      {:httpoison, "~> 1.3.1", override: true},
      {:jason, "~> 1.0"},
      {:amqp, "~> 1.0"},
      {:ranch_proxy_protocol, "~> 2.0", override: true},
      {:distillery, "~> 2.0"}
    ]
  end
end
