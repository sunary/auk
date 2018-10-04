defmodule A do
    use GenStage

    def start_link(state) do 
      GenStage.start_link(__MODULE__, state, name: state.atom_module)
    end
  
    def init(state) do
      App.Registry.monitor(self(), state.atom_module)
      {:producer, state}
    end
  
    def handle_demand(demand, state) when demand > 0 do
      # If the counter is 3 and we ask for 2 items, we will
      # emit the items 3 and 4, and set the state to 5.
      events = Enum.to_list(state.counter..state.counter+demand-1)

      case :pg2.get_members(Auk.pg2_group()) do
        {:error, {:no_such_group, _}} ->
          nil
        pids ->
          for pid <- pids do
            if pid != self() do
              send(pid, {:pg2_msg, "Hello"})
            end
          end
      end

      {:noreply, events, %{state | counter: state.counter + demand}}
    end

    def handle_info({:pg2_msg, message}, state) do
      IO.inspect "[#{inspect state.atom_module}] got #{inspect message} from :pg2_group"
      {:noreply, [], state}
    end
end
