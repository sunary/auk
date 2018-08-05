defmodule App.Supervisor do
  use GenServer
  require Logger

  def start_link({name, config_exs}) do
    Logger.debug "[App.Supervisor] start Supervisor: #{name}"

    GenServer.start_link(__MODULE__, {name, config_exs}, name: {:global, name})
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
    {:ok, name}
  end
end