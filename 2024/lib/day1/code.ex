defmodule Advent2024.Day1 do
  require Logger

  def part1(input) do
    Logger.info("Running 2024-1-P1-InputList")
    {left_list, right_list} = build_lists_from_input(input) |> sort_lists()
    reduce_over_lists({left_list, right_list}, &calculate_sum_of_diffs/2, 0)
  end

  defp build_lists_from_input(input) do
    Enum.reduce(input, {[], []}, fn row, {left_list, right_list} ->
      [left, right] = String.split(row, ~r/\s{3}/)
      {[String.to_integer(left) | left_list], [String.to_integer(right) | right_list]}
    end)
  end

  defp sort_lists({left_list, right_list}) do
    {Enum.sort(left_list, &<=/2), Enum.sort(right_list, &<=/2)}
  end

  defp reduce_over_lists({left_list, right_list}, fun, starting_value) do
    left_list
    |> Enum.zip(right_list)
    |> Enum.reduce(starting_value, fun)
  end

  defp calculate_sum_of_diffs({left, right}, acc) do
    acc + abs(right - left)
  end

  def part2(input) do
    Logger.info("Running 2024-1-P2-InputList")
    {left_list, right_list} = build_lists_from_input(input)
    right_list_frequency_map = Enum.frequencies(right_list)
    Enum.reduce(left_list, 0, fn left, acc ->
      similarity_score = Map.get(right_list_frequency_map, left, 0)
      acc + (left * similarity_score)
    end)
  end
end
