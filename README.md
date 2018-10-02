# Elixir pipeline

Elixir pipeline using genstage

## Structure

```
  .
  +-- components/
  +-- assemblies/
  |   +-- job1/
  |       +-- app_config.exs
  |   +-- job2/
  |       +-- app_config.exs
  |   +-- job3/
  |       +-- app_config.exs
  +-- functions/
  +-- test/
  +-- mix.exs
```

## Installation

```sh
$ mix deps.get
```

## Run

```sh
$ MIX_ENV=dev iex --name a@127.0.0.1 -S mix
$ MIX_ENV=dev iex --name b@127.0.0.1 -S mix
$ MIX_ENV=dev iex --name c@127.0.0.1 -S mix
```