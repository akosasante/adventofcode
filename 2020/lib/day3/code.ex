  defmodule Advent2020.Day3 do
    import Helpers.Shared, only: [log: 1]

    def part1(input) do
      log("Running 2020-3-P1-InputList")
      {_, sum} = travel_slope_and_count_trees(input, {1, 3})

      sum
    end

    def part1_optimized(input) do
      log("Running 2020-3-P1-InputListOptimized")
      "Not implemented"
    end

    def part1_stream(input_stream) do
      log("Running 2020-3-P1-InputStream")
      "Not implemented"
    end

    def part2(input) do
      log("Running 2020-3-P2-InputList")
      given_slopes = [
        {1,1},
        {1, 3},
        {1, 5},
        {1, 7},
        {2, 1}
      ]
      Enum.reduce(given_slopes, 1, fn slope, sum ->
        {_, num_trees} = travel_slope_and_count_trees(input, slope)
        log("===========Sum for #{inspect slope} was: #{num_trees}=============\n\n")
        sum * num_trees
      end)
    end

    def part2_optimized(input) do
      log("Running 2020-3-P2-InputListOptimized")
      "Not implemented"
    end

    def part2_stream(input_stream) do
      log("Running 2020-3-P2-InputStream")
      "Not implemented"
    end

    defp travel_slope_and_count_trees(input, {down_step, right_step}) do
      log("Checking for slope=#{inspect({down_step, right_step})}")
      input
      |> Enum.with_index()
      |> Enum.reduce({right_step, 0}, fn {row, row_index}, {column_index, num_trees} ->
        if (row_index > 0) and (rem(row_index, down_step) == 0) do
          effective_index = rem(column_index, String.length(row))
          {beginning, rest} = String.split_at(row, effective_index)
          {thing, rest} = String.split_at(rest, 1)
          custom = beginning <> IO.ANSI.blue() <> thing <> IO.ANSI.reset() <> rest
          log("#{custom} #{inspect {row_index, column_index, effective_index, num_trees}}")
          case String.at(row, effective_index) do
            "#" -> {column_index + right_step, num_trees + 1}
            _ -> {column_index + right_step, num_trees}
          end
        else
          log("#{row} #{inspect({row_index, column_index, "skipping row", num_trees})}")
          {column_index, num_trees}
        end
      end)
    end
  end
