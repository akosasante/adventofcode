defmodule Advent2024.MixProject do
  use Mix.Project

  def project do
    [
      app: :advent_2024,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:advent_of_code_helper, ">= 0.0.0"},
      {:benchee, ">= 0.0.0"},
      {:credo, ">= 0.0.0", only: [:dev, :test], runtime: false},
      {:dialyxir, ">= 0.0.0", only: [:dev], runtime: false},
      {:libgraph, ">= 0.0.0"}
    ]
  end
end
