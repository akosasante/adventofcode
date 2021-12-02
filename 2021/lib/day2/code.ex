  defmodule Advent2021.Day2 do
    import Helpers.Shared, only: [log: 1]

    def part1(input) do
      log("Running 2021-2-P1-InputList")
      Enum.reduce(input, [depth: 0, distance: 0], fn direction, [depth: dy, distance: dx] ->
        case String.split(direction, " ") do
          ["forward", amount] -> [depth: dy, distance: dx + String.to_integer(amount)]
          ["up", amount] -> [depth: dy - String.to_integer(amount), distance: dx]
          ["down", amount] -> [depth: dy + String.to_integer(amount), distance: dx]
        end
      end)
      |> Keyword.values()
      |> Enum.product()
    end

    def part1_optimized(input) do
      log("Running 2021-2-P1-InputListOptimized")
      "Not implemented"
    end

    def part1_stream(input_stream) do
      log("Running 2021-2-P1-InputStream")
      "Not implemented"
    end

    def part2(input) do
      log("Running 2021-2-P2-InputList")
      Enum.reduce(input, [depth: 0, distance: 0, aim: 0], fn direction, [depth: dy, distance: dx, aim: aim] ->
        case String.split(direction, " ") do
          ["forward", amount] ->
            amount = String.to_integer(amount)
            [depth: dy + (aim * amount), distance: dx + amount, aim: aim]
          ["up", amount] -> [depth: dy, distance: dx, aim: aim - String.to_integer(amount)]
          ["down", amount] -> [depth: dy, distance: dx, aim: aim + String.to_integer(amount)]
        end
      end)
      |> Keyword.take([:depth, :distance])
      |> Keyword.values()
      |> Enum.product()
    end

    def part2_optimized(input) do
      log("Running 2021-2-P2-InputListOptimized")
      "Not implemented"
    end

    def part2_stream(input_stream) do
      log("Running 2021-2-P2-InputStream")
      "Not implemented"
    end
  end
