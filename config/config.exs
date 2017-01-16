# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :welcome,
  ecto_repos: [Welcome.Repo]

# Configures the endpoint
config :welcome, Welcome.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "VXivFMoBSoof6KPWguzR110xY74ZGR22r9zt9A8KZjE6V4tDaRllmFxEemdBbMQ6",
  render_errors: [view: Welcome.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Welcome.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures mailer
config :welcome, Welcome.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "smtp.domain",
  port: 1025,
  username: System.get_env("SMTP_USERNAME"),
  password: System.get_env("SMTP_PASSWORD"),
  tls: :if_available, # can be `:always` or `:never`
  ssl: false, # can be `true`
  retries: 1

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
