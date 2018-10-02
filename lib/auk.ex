defmodule Auk do
  use Application
  require Logger

  @pg2_group :auk_workers

  def start(_type, args) do
    import Supervisor.Spec, warn: false
    Logger.info "[Auk] Starting Auk Application"
    
    children = Enum.map(args, fn [x] ->
      name = Helpers.App.gen_component_name(x)
      Supervisor.child_spec({App.Wrapper, {name, x}}, id: name)
    end)

    children = [
      supervisor(Registry, [:unique, GlobalRegistry]),
      worker(App.Registry, []),
      worker(MailboxAggregator, [])
      ] ++ children
    opts = [strategy: :one_for_one, name: __MODULE__]
    
    Supervisor.start_link(children, opts)
  end

  def pg2_group, do: @pg2_group
end
