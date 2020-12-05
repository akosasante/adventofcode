defmodule Advent2020.Day3 do
  import Helpers.Shared, only: [log: 1]

  def part1(input) do
    log("Running 2020-3-P1-InputList")
    {_, sum} = travel_slope_and_count_trees(input, {1, 3})

    sum
  end

  def part1_optimized(input) do
    log("Running 2020-3-P1-InputListOptimized")
    get_trees_variant_two(input, {1, 3})
  end

  def part1_stream(input_stream) do
    log("Running 2020-3-P1-InputStream")
    "Not implemented"
  end

  def part2(input) do
    log("Running 2020-3-P2-InputList")

    given_slopes = [
      {1, 1},
      {1, 3},
      {1, 5},
      {1, 7},
      {2, 1}
    ]

    Enum.reduce(given_slopes, 1, fn slope, sum ->
      {_, num_trees} = travel_slope_and_count_trees(input, slope)
      log("===========Sum for #{inspect(slope)} was: #{num_trees}=============\n\n")
      sum * num_trees
    end)
  end

  def part2_optimized(input) do
    log("Running 2020-3-P2-InputListOptimized")

    given_slopes = [
      {1, 1},
      {1, 3},
      {1, 5},
      {1, 7},
      {2, 1}
    ]

    Enum.reduce(given_slopes, 1, fn slope, sum ->
      num_trees = get_trees_variant_two(input, slope)
      log("===========Sum for #{inspect(slope)} was: #{num_trees}=============\n\n")
      sum * num_trees
    end)
  end

  def part2_stream(input_stream) do
    log("Running 2020-3-P2-InputStream")
    "Not implemented"
  end

  defp travel_slope_and_count_trees(input, {down_step, right_step}) do
    # loop through input once to generate indices :/
    # loop through input again to get the rows; for each row, get value of String at
    # so that's either O(len_of_input * len_of_string) or if String.at is close to constant then just O(len_of_input)
    log("Checking for slope=#{inspect({down_step, right_step})}")

    input
    |> Enum.with_index()
    |> Enum.reduce({right_step, 0}, fn {row, row_index}, {column_index, num_trees} ->
      if row_index > 0 and rem(row_index, down_step) == 0 do
        effective_index = rem(column_index, String.length(row))
        {beginning, rest} = String.split_at(row, effective_index)
        {thing, rest} = String.split_at(rest, 1)
        custom = beginning <> IO.ANSI.blue() <> thing <> IO.ANSI.reset() <> rest
        log("#{custom} #{inspect({row_index, column_index, effective_index, num_trees})}")

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

  defp calculate_visited_rows(rows, down_step) do
    Enum.take_every(rows, down_step) |> Enum.drop(1)
  end

  defp calculate_visited_columns([first_row | _], right_step) do
    row_length = String.length(first_row)

    Range.new(0, row_length * right_step - 1)
    |> Enum.take_every(right_step)
    |> Enum.map(fn n -> rem(n, row_length) end)
  end

  defp get_trees_sum(visited_rows, visited_columns) do
    Stream.cycle(visited_columns)
    |> Enum.take(length(visited_rows) + 1)
    |> Enum.drop(1)
    |> Enum.zip(visited_rows)
    |> Enum.count(fn {at, row} ->
      {beginning, rest} = String.split_at(row, at)
      {thing, rest} = String.split_at(rest, 1)
      custom = beginning <> IO.ANSI.blue() <> thing <> IO.ANSI.reset() <> rest
      log("#{custom}")
      String.at(row, at) == "#"
    end)
  end

  defp get_trees_variant_two(input, {down_slope, right_slope}) do
    visited_rows = calculate_visited_rows(input, down_slope)
    visited_columns = calculate_visited_columns(input, right_slope)
    get_trees_sum(visited_rows, visited_columns)
  end
end
