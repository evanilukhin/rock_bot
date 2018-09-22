# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config
    
config :nadia,
  recv_timeout: 30

import_config "#{Mix.env()}.exs"
