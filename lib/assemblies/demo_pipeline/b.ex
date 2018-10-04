defmodule B do
  use GenStage

  def start_link({subscription, state}) do 
    GenStage.start_link(__MODULE__, {subscription, state}, name: state.atom_module)
  end

  def init({subscription, state}) do
    {:producer_consumer, state, subscribe_to: [subscription]}
  end

  def handle_events(events, _from, state) do
    # If we receive [0, 1, 2], this will transform
    # it into [0, 1, 2, 1, 2, 3, 2, 3, 4].

    events =
      for event <- events,
          entry <- event..event+state.number,
          do: entry

    MailboxWrapper.send(MailboxAggregator, 
      {&IO.inspect/1, "This message exposed from [#{inspect state.atom_module}] at: #{DateTime.utc_now}"})

      {:noreply, events, state}
  end
end