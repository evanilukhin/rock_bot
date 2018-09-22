use Mix.Config

config :amqp,
  username: "${RABBIT_LOGIN}",
  password: "${RABBIT_PASS}",
  host: "${RABBIT_HOST}",
  port: "${RABBIT_PORT}"

config :nadia,
  token: "${TELEGRAM_BOT_TOKEN}",
  base_url: "${TELEGRAM_API_BASE_URL}"
