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

    opts = [strategy: :one_for_one]
    Supervisor.start_link(children, opts)
    {:ok, name}
  end
end