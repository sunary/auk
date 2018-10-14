defmodule KafkaConsumer do
  use GenStage
  require Logger

  alias KafkaEx.Protocol.Fetch.Message
  alias KafkaEx.Protocol.Offset.Response

  def start_link(state) do
    Logger.debug "[#{inspect state.atom_module}] start"

    GenStage.start_link(__MODULE__, state, name: state.atom_module)
  end

  def init(state) do
    Application.ensure_all_started(:kafka_ex)

    brokers = case state.kafka_url do
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
    KafkaEx.create_worker(state.worker_name, [
      uris: brokers,
      consumer_group: :no_consumer_group,
      sync_timeout: 3000,
      max_seconds: 60,
      max_restarts: 10])
    {:producer, state}
  end

  def handle_demand(demand, state) when demand > 0 do
    [%Response{partition_offsets: [%{offset: [offset]}]}] = KafkaEx.latest_offset(state.topic, 0, state.worker_name)
    events =
      KafkaEx.stream(state.topic, 0, offset: offset, auto_commit: false, worker_name: state.worker_name)
      |> Enum.take(demand)
      |> Enum.map(fn(%Message{value: value}) ->value end)

    {:noreply, events, state}
  end
end
