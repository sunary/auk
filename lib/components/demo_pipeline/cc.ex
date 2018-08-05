defmodule CC do
  use GenStage

  def start_link({subscription, state}) do
    GenStage.start_link(__MODULE__, {subscription, state}, name: state.atom_module)
  end

  def init({subscription, state}) do
    {:consumer, state, subscribe_to: [subscription]}
  end

  def handle_events(events, _from, state) do
    # Wait for a second.
    :timer.sleep(1000)

    IO.inspect(events, label: Atom.to_string(state.atom_module))
    {:noreply, [], state}
  end
end