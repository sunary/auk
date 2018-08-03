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
        ["lib/components/demo_pipeline/app_config.exs"]
      ]},
      applications: [],
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:gen_stage, "~> 0.14"}
    ]
  end
end
