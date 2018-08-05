defmodule Helpers.App do
  
  @doc """
  ## Example
  ```elixir
  iex> Helpers.App.gen_component_name("lib/jobs/demo_pipeline/app_config.exs")
  "demo_pipeline"
  iex> Helpers.App.gen_component_name("lib/jobs/bitstamp_websocket_orderbook/app_config.exs")
  "bitstamp_websocket_orderbook"
  ```
  """
  def gen_component_name(config_file) do
    {dir, _} = List.pop_at(String.split(config_file, "/"), 2)
    String.to_atom(dir)
  end

  def gen_module_atom(component_name, module) do
    Atom.to_string(component_name) <> "_" <> Atom.to_string(module)
      |> String.replace(".", "")
      |> String.to_atom
  end
end