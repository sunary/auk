defmodule Auk do
  use Application
  require Logger

  def start(_type, args) do
    import Supervisor.Spec, warn: false
    Logger.info "[Auk] Starting Auk Application"
    
    children = Enum.map(args, fn [x] ->
      name = Helpers.App.get_name_from_config_exs(x)
      Supervisor.child_spec({App.Supervisor, {name, x}}, id: name)
    end)

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end
end
