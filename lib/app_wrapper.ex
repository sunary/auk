defmodule App.Wrapper do
  use GenServer
  require Logger

  @kill_delay 10_000

  def start_link({name, config_exs}) do
    GenServer.start_link(__MODULE__, {name, config_exs})
  end

  def init({name, config_exs}) do
    App.Registry.register({name, config_exs})

    {:ok, name}
  end
end