use Mix.Config

config :amqp,
  username: System.get_env("RABBIT_LOGIN"),
  password: System.get_env("RABBIT_PASS"),
  host: System.get_env("RABBIT_HOST"),
  port: System.get_env("RABBIT_PORT")

config :nadia,
  token: System.get_env("TELEGRAM_BOT_TOKEN"),
  base_url: System.get_env("TELEGRAM_API_BASE_URL")
