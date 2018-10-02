# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :logger,
  level: :debug,
  truncate: :infinity,
  utc_log: true

kafka_url = System.get_env("KAFKA_URL") || "http://localhost:9092"
brokers = case kafka_url do
  nil ->
    []
  value ->
    value
    |> String.split(",")
    |> Enum.map(
      fn(url) ->
        uri = URI.parse(url)
        {uri.host, uri.port || 9092}
      end
    )
end
config :kafka_ex,
  brokers: brokers,
  consumer_group: :no_consumer_group,
  disable_default_worker: true,
  sync_timeout: 3000,
  max_restarts: 10,
  max_seconds: 60,
  use_ssl: false,
  kafka_version: "0.9.0"

config :auk,
  kafka_consumer_url: System.get_env("KAFKA_CONSUMER_URL") || "http://localhost:9092"

import_config "#{Mix.env}.exs"

