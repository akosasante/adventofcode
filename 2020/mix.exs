defmodule Advent2020.MixProject do
  use Mix.Project

  def project do
    [
      app: :advent2020,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      consolidate_protocols: true
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:finch, "~> 0.5"},
      {:benchee, "~> 1.0"},
      {:ecto_sql, "~> 3.0"},
      {:libgraph, "~> 0.7"}
    ]
  end
end
