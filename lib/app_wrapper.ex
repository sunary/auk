defmodule App.Wrapper do
  use GenServer
  require Logger

  @kill_delay 10_000

  def start_link({name, config_exs}) do
    GenServer.start_link(__MODULE__, {name, config_exs})
  end

  def init({name, config_exs}) do
    App.Registry.register({name, config_exs})

    # Process.send_after(self(), :random_kill, @kill_delay)
    {:ok, name}
  end

  def handle_info(:random_kill, state) do
    case :pg2.get_local_members(Auk.pg2_group()) do
      [pid | _] when is_pid(pid) -> stop_server(pid)
      _ -> nil
    end

    Process.send_after(self(), :random_kill, @kill_delay)
    {:noreply, state}
  end

  defp stop_server(pid) do
    {m, f, reason} = case :rand.uniform(5) do
      1 -> {GenServer, :stop, {:error, :rand_kill}}
      2 -> {GenServer, :stop, :normal}
      3 -> {GenServer, :stop, :shutdown}
      4 -> {App.Supervisor, :raise, "Triggered by App.Wrapper"}
      5 -> {Process, :exit, {:error, :rand_kill}}
    end
    name = App.Supervisor.get_name(pid)
    Logger.error("[App.Wrapper] stopping #{name} with: #{m}.#{f}(#{inspect(pid)}, #{inspect(reason)})")
    apply(m, f, [pid, reason])
  end
end