defmodule BB do
  use GenStage

  def start_link({subscription, init_state}) do 
    GenStage.start_link(__MODULE__, {subscription, init_state}, name: __MODULE__)
  end

  def init({subscription, number}) do
    {:producer_consumer, number, subscribe_to: [subscription]}
  end

  def handle_events(events, _from, number) do
    # If we receive [0, 1, 2], this will transform
    # it into [0, 1, 2, 1, 2, 3, 2, 3, 4].

    events =
      for event <- events,
          entry <- event..event+number,
          do: entry

    # IO.inspect(events, label: "BB")
    {:noreply, events, number}
  end
end