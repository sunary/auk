defmodule App.Registry do
  use GenServer
  require Logger

  def start_link do
    Logger.debug "[App.Registry] start"
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def register({name, config_exs}) do
    Logger.debug "[App.Registry] Register job: #{name}"
    GenServer.call(__MODULE__, {:register, {name, config_exs}})
  end

  def monitor(pid, name) do
    Logger.debug "[App.Registry] monitor #{name}"
    GenServer.cast(__MODULE__, {:monitor, pid, name})
  end

  def init(_) do
    Process.flag(:trap_exit, true)
    {:ok, %{}}
  end

  def handle_cast({:monitor, pid, name}, state) do
    :pg2.create(Auk.pg2_group())
    :pg2.join(Auk.pg2_group(), pid)
    ref = Process.monitor(pid)
    {:noreply, Map.put(state, ref, name)}
  end

  def handle_call({:register, {name, config_exs}}, _from, state) do
    case start_via_swarm({name, config_exs}) do
      {:ok, pid} ->
        {:reply, {:ok, pid}, state}
      {:already_registered, pid} ->
        Logger.debug "[App.Registry] :already_registered"
        {:reply, {:ok, pid}, state}
      {:error, reason} ->
        Logger.error("[App.Registry] error starting #{name} - #{inspect(reason)}")
        {:reply, {:error, reason}, state}
    end
  end

  def handle_info({:DOWN, ref, :process, _pid, :normal}, state) do
    {:noreply, Map.delete(state, ref)}
  end

  def handle_info({:DOWN, ref, :process, _pid, :shutdown}, state) do
    {:noreply, Map.delete(state, ref)}
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, state) do
    case Map.get(state, ref) do
      nil ->
        {:noreply, state}
      {name, config_exs} ->
        {:ok, _pid} = start_via_swarm({name, config_exs}, "restarting")
        {:noreply, Map.delete(state, ref)}
    end
  end

  def start_via_swarm({name, config_exs}, reason \\ "starting") do
    Logger.debug("[App.Registry] #{reason} via swarm: #{name}")
    Swarm.register_name(name, App.Supervisor, :register, [{name, config_exs}])
  end
end