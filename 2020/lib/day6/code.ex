defmodule Advent2020.Day6 do
  import Helpers.Shared, only: [log: 1]

  def part1(input) do
    log("Running 2020-6-P1-InputList")

    input
    |> Enum.map(fn group ->
      group
      |> String.graphemes()
      |> Enum.reject(fn val -> val == "\n" end)
      |> Enum.uniq()
      |> Enum.count()
    end)
    |> Enum.sum()
  end

  def part1_optimized(input) do
    log("Running 2020-6-P1-InputListOptimized")
    "Not implemented"
  end

  def part1_stream(input_stream) do
    log("Running 2020-6-P1-InputStream")
    "Not implemented"
  end

  def part2(input) do
    log("Running 2020-6-P2-InputList")

    Enum.map(input, fn group ->
      number_of_members_in_group =
        group
        |> String.split("\n", trim: true)
        |> Enum.count()

      group
      |> String.graphemes()
      |> Enum.reject(fn val -> val == "\n" end)
      |> Enum.frequencies()
      |> Enum.filter(fn {_letter, num_seen} -> num_seen == number_of_members_in_group end)
      |> Enum.count()
    end)
    |> Enum.sum()
  end

  def part2_optimized(input) do
    log("Running 2020-6-P2-InputListOptimized")
    "Not implemented"
  end

  def part2_stream(input_stream) do
    log("Running 2020-6-P2-InputStream")
    "Not implemented"
  end
end
