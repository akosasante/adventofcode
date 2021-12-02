  defmodule Advent2021.Day1 do
    import Helpers.Shared, only: [log: 1]

    def part1(input) do
      log("Running 2021-1-P1-InputList")
      input
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2, 1)
      |> Enum.reduce(0, fn
        [prev_depth, curr_depth], num_increases -> if prev_depth < curr_depth, do: num_increases + 1, else: num_increases
        [last_depth], num_increases -> num_increases
      end)
    end

    def part1_optimized(input) do
      log("Running 2021-1-P1-InputListOptimized")
      "Not implemented"
    end

    def part1_stream(input_stream) do
      log("Running 2021-1-P1-InputStream")
      "Not implemented"
    end

    def part2(input) do
      log("Running 2021-1-P2-InputList")
      input
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(3, 1)
      |> Enum.map(fn
        [_, _, _] = sliding_window -> Enum.sum(sliding_window)
        _ -> nil
      end)
      |> Enum.reject(&is_nil/1)
      |> Enum.chunk_every(2, 1)
      |> Enum.reduce(0, fn
        [prev_sliding_depth, curr_sliding_depth], num_increases -> if prev_sliding_depth < curr_sliding_depth, do: num_increases + 1, else: num_increases
        [last_sliding_depth], num_increases -> num_increases
      end)
    end

    def part2_optimized(input) do
      log("Running 2021-1-P2-InputListOptimized")
      "Not implemented"
    end

    def part2_stream(input_stream) do
      log("Running 2021-1-P2-InputStream")
      "Not implemented"
    end
  end
