defmodule Helpers.App do
  
  @doc """
  ## Example
  ```elixir
  iex> Helpers.App.get_name_from_config_exs("lib/jobs/demo_pipeline/app_config.exs")
  "demo_pipeline"
  iex> Helpers.App.get_name_from_config_exs("lib/jobs/bitstamp_websocket_orderbook/app_config.exs")
  "bitstamp_websocket_orderbook"
  ```
  """
  def get_name_from_config_exs(filepath) do
    {dir, _} = List.pop_at(String.split(filepath, "/"), 2)
    String.to_atom(dir)
  end
end