defmodule CC do
  use GenStage

  def start_link({subscription, init_state}) do
    GenStage.start_link(__MODULE__, {subscription, init_state}, name: __MODULE__)
  end

  def init({subscription, :ok}) do
    {:consumer, :the_state_does_not_matter, subscribe_to: [subscription]}
  end

  def handle_events(events, _from, state) do
    # Wait for a second.
    :timer.sleep(1000)

    IO.inspect(events, label: "CC")
    {:noreply, [], state}
  end
end