import Supervisor.Spec, warn: false

[
  worker(AA,
        [0]),
  worker(BB,
        [{{AA, min_demand: 1, max_demand: 10}, 2}]),
  worker(CC,
        [{{BB, min_demand: 1, max_demand: 10}, :ok}])
]
