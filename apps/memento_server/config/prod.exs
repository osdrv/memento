use Mix.Config

config :memento_server, MementoServer.Repo,
  database: "memento.notes"

config :logger, level: :info
