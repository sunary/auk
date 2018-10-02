defmodule Auk.MixProject do
  use Mix.Project

  def project do
    [
      app: :auk,
      version: "0.1.0",
      elixir: "~> 1.6",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Auk, [
        ["lib/assemblies/demo_pipeline/app_config.exs"]
      ]},
      applications: [:libcluster, :swarm],
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:gen_stage, "~> 0.14"},
      {:libcluster, "~> 2.5.0"},
      {:swarm, "~> 2.0.2"}
    ]
  end
end
