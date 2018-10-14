defmodule KafkaProducer do
  use GenStage
  require Logger

  alias KafkaEx.Protocol.Produce.Message
  alias KafkaEx.Protocol.Produce.Request

  def start_link({subscription, state}) do 
    Logger.debug "[#{inspect state.atom_module}] start"

    GenStage.start_link(__MODULE__, {subscription, state}, name: state.atom_module)
  end

  def init({subscription, state}) do
    KafkaEx.create_worker(state.worker_name)
    
    {:consumer, state, subscribe_to: [subscription]}
  end

  def handle_events(events, _from, state) do
    messages = events
      |> Enum.map(fn x -> %Message{value: x} end)

    produce_request = %Request{
      topic: state.topic,
      partition: 0,
      required_acks: 1,
      messages: messages
    }
          
    KafkaEx.produce(produce_request, worker_name: state.worker_name)
    Logger.debug "[#{inspect state.atom_module}] Sent #{inspect Kernel.length(messages)} messages to topic: #{state.topic}"

    {:noreply, [], state}
  end
end
