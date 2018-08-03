defmodule AA do
    use GenStage

    def start_link(init_state) do 
      case GenStage.start_link(__MODULE__, init_state, name: __MODULE__) do
        {:ok, pid} ->
          {:ok, pid}
        {:error, {:already_started, pid}} ->
          Process.link(pid)
          {:ok, pid}
      end
    end
  
    def init(counter) do
      {:producer, counter}
    end
  
    def handle_demand(demand, counter) when demand > 0 do
      # If the counter is 3 and we ask for 2 items, we will
      # emit the items 3 and 4, and set the state to 5.
      events = Enum.to_list(counter..counter+demand-1)

      # IO.inspect(events, label: "AA")
      {:noreply, events, counter + demand}
    end
end