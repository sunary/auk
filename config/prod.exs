use Mix.Config

config :libcluster,
  topologies: [
    k8s: [
      strategy: Cluster.Strategy.Kubernetes.DNS,
      config: [
        service: "auk-headless",
        application_name: "auk",
        polling_interval: 10_000]
      ]
  ]