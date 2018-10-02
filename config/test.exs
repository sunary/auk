use Mix.Config

config :libcluster,
  topologies: [
    epmd: [
      strategy: Cluster.Strategy.Epmd,
      config: [
        hosts: ~w(a@127.0.0.1 b@127.0.0.1 c@127.0.0.1)a
      ]
    ]
  ]