defmodule Advent2020.Day5 do
  import Helpers.Shared, only: [log: 1]

  @start_vals {{0, 127, 0, 7}, {nil, nil}}

  def part1(input) do
    log("Running 2020-5-P1-InputList")

    Enum.map(input, &parse_seat_ids/1)
    |> get_highest_seat_id()
  end

  def part1_optimized(input) do
    log("Running 2020-5-P1-InputListOptimized")
    "Not implemented"
  end

  def part1_stream(input_stream) do
    log("Running 2020-5-P1-InputStream")
    "Not implemented"
  end

  def part2(input) do
    log("Running 2020-5-P2-InputList")
    list_of_seat_ids = Enum.map(input, &parse_seat_ids/1)
    |> Enum.sort()

    expected_sum = expected_sum_of_list(list_of_seat_ids)
    actual_sum = Enum.sum(list_of_seat_ids)

    expected_sum - actual_sum
  end

  def part2_optimized(input) do
    log("Running 2020-5-P2-InputListOptimized")
    "Not implemented"
  end

  def part2_stream(input_stream) do
    log("Running 2020-5-P2-InputStream")
    "Not implemented"
  end

  defp parse_seat_ids(boarding_pass) do
    {_, final_row_and_column} =
      boarding_pass
      |> String.graphemes()
      |> Enum.reduce(@start_vals, fn row_instructions,
                                     {{min_row, max_row, min_col, max_col}, {res_row, res_col}} ->
        if row_instructions in ["F", "B"] do
          halves = get_halves({min_row, max_row})

          case choose_half(halves, row_instructions) do
            new_min..new_max -> {{new_min, new_max, min_col, max_col}, {res_row, res_col}}
            final_value -> {{min_row, max_row, min_col, max_col}, {final_value, res_col}}
          end
        else
          halves = get_halves({min_col, max_col})

          case choose_half(halves, row_instructions) do
            new_min..new_max -> {{min_row, max_row, new_min, new_max}, {res_row, res_col}}
            final_value -> {{min_row, max_row, min_col, max_col}, {res_row, final_value}}
          end
        end
      end)

    calculate_seat_id(final_row_and_column, "part1")
  end

  defp choose_half({bottom_half_range, _}, "F"), do: bottom_half_range
  defp choose_half({bottom_half_range, _}, "L"), do: bottom_half_range
  defp choose_half({_, top_half_range}, "B"), do: top_half_range
  defp choose_half({_, top_half_range}, "R"), do: top_half_range

  defp get_halves({min, max}) when max - min == 1, do: {min, max}

  defp get_halves({min, max}) do
    mid =
      min..max
      |> Enum.count()
      |> Kernel./(2)
      |> floor()
      |> Kernel.+(min)

    bottom_range = min..(mid - 1)
    top_range = mid..max
    {bottom_range, top_range}
  end

  defp calculate_seat_id({row, column}, "part1") do
    row * 8 + column
  end

  defp get_highest_seat_id(seat_ids) do
    Enum.max(seat_ids)
  end

  defp expected_sum_of_list(list_of_seat_ids) do
    # Using the formulat to find sum of consecutive numbers (idr what it's called; Gauss?)
    first_val = List.first(list_of_seat_ids)
    last_val = List.last(list_of_seat_ids)
    ((first_val + last_val) / 2)
    |> Kernel.*(length(list_of_seat_ids) + 1) #plus one because our list is missing one boarding pass!
    |> floor()
  end
end
