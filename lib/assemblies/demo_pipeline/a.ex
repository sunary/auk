defmodule A do
    use GenStage

    def start_link(state) do 
      GenStage.start_link(__MODULE__, state, name: state.atom_module)
    end
  
    def init(state) do
      {:producer, state}
    end
  
    def handle_demand(demand, state) when demand > 0 do
      # If the counter is 3 and we ask for 2 items, we will
      # emit the items 3 and 4, and set the state to 5.
      events = Enum.to_list(state.counter..state.counter+demand-1)

      # IO.inspect(events, label: "AA")
      {:noreply, events, %{state | counter: state.counter + demand}}
    end
end