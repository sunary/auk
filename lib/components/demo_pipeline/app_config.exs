import Supervisor.Spec, warn: false

[
  worker(AA,
        [%{
          counter: 0
        }]),
  worker(BB,
        [{{AA, min_demand: 1, max_demand: 10},
          %{
            number: 2
          }}]),
  worker(CC,
        [{{BB, min_demand: 1, max_demand: 10},
          %{}}])
]
