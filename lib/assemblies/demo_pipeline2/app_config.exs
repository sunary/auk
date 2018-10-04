import Supervisor.Spec, warn: false

[
  worker(A,
        [%{
          counter: 0
        }]),
  worker(B,
        [{{A, min_demand: 1, max_demand: 20},
          %{
            number: 2
          }}]),
  worker(C,
        [{{B, min_demand: 1, max_demand: 20},
          %{}}])
]
