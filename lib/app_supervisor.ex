defmodule App.Supervisor do
  use GenServer
  require Logger

  def start_link({name, config_exs}) do
    Logger.debug "[App.Supervisor] start Supervisor: #{name}"

    GenServer.start_link(__MODULE__, {name, config_exs}, name: name)
  end

  def init({name, config_exs}) do
    import Supervisor.Spec, warn: false
    children = config_exs
      |> Code.eval_file()
      |> elem(0)
      |> Enum.map(fn child ->
        case child do
          {module, {module, :start_link, [{{previous_module, demand}, params}]}, x1, x2, x3, x4} ->
            previous_module = Helpers.App.gen_module_atom(name, previous_module)
            params = params |> Map.put(:atom_module, Helpers.App.gen_module_atom(name, module))
            {module, {module, :start_link, [{{previous_module, demand}, params}]}, x1, x2, x3, x4}
          {module, {module, :start_link, [params]}, x1, x2, x3, x4} ->
            params = params |> Map.put(:atom_module, Helpers.App.gen_module_atom(name, module))
            {module, {module, :start_link, [params]}, x1, x2, x3, x4}
        end
      end)

    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)

    App.Registry.monitor(self(), name)
    {:ok, name}
  end

  def register({name, config_exs}) do
    Logger.debug "[App.Supervisor] register Supervisor: #{name}"
    {:ok, _pid} = start_link({name, config_exs})
  end

  def handle_call({:swarm, :begin_handoff}, _from, name) do
    Logger.info("[App.Supervisor] begin_handoff: #{name}")
    {:reply, :resume, name}
  end

  def handle_cast({:swarm, :end_handoff}, name) do
    Logger.info("[App.Supervisor] begin_handoff: #{name}")
    {:noreply, name}
  end

  def handle_cast({:swarm, :resolve_conflict}, name) do
    Logger.info("[App.Supervisor] resolve_conflict: #{name}")
    {:noreply, name}
  end

  def handle_info({:swarm, :die}, name) do
    Logger.info("[App.Supervisor] swarm stopping worker: #{name}")
    {:stop, :normal, name}
  end

  def get_name(name) do
    name
  end
end