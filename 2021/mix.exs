defmodule Advent2021.MixProject do
  use Mix.Project

  def project do
    [
      app: :advent_2021,
      version: "0.1.0",
      elixir: "~> 1.12",
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
      {:benchee, "~> 1.0"},
      {:advent_of_code_helper, "~> 0.2.1"}
    ]
  end
end
