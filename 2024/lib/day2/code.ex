defmodule Advent2024.Day2 do
  require Logger

  def part1(input) do
    Logger.info("Running 2024-2-P1-InputList")
    validate_input(input)
  end

  defp validate_input(input) do
    Enum.reduce(input, 0, fn report, safe_results ->
      case validate_report(prepare_report(report)) do
        {:nonsequential_direction, _} -> safe_results
        {:nongradual_difference, _} -> safe_results
        _ -> safe_results + 1
      end
    end)
  end

  defp prepare_report(report) do
    IO.inspect(report)
    report
    |> String.split(~r/\s/)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk_every(2, 1, :discard)
  end

  defp validate_report(report) do
    Enum.reduce_while(report, nil, fn [reading1, reading2], direction ->
      difference = reading2 - reading1
      new_direction = get_direction(difference)

      cond do
        abs(difference) > 3 -> {:halt, {:nongradual_difference, report}}
        abs(difference) < 1 -> {:halt, {:nongradual_difference, report}}
        is_nil(direction) -> {:cont, new_direction}
        direction != new_direction -> {:halt, {:nonsequential_direction, report}}
        true -> {:cont, new_direction}
      end
    end)
  end

  defp get_direction(difference) do
    cond do
      difference > 0 -> :up
      difference < 0 -> :down
      true -> :flat
    end
  end

  def part2(input) do
    Logger.info("Running 2024-2-P2-InputList")
    recursively_validate_input(input)
  end

  defp recursively_validate_input(input) do
    Enum.reduce(input, 0, fn report, safe_results ->
      case recursively_validate_row(report) do
        false -> safe_results
        true -> safe_results + 1
      end
    end)
  end

  defp recursively_validate_row(report) do
    row =
      report
      |> String.split(~r/\s/)
      |> Enum.map(&String.to_integer/1)

    Enum.any?(-1..length(row), fn index ->
      result =
        if index == -1 do
          validate_report(Enum.chunk_every(row, 2, 1, :discard))
        else
          row
          |> Enum.with_index()
          |> Enum.reject(fn {_, i} -> i == index end)
          |> Enum.map(&elem(&1, 0))
          |> Enum.chunk_every(2, 1, :discard)
          |> validate_report
        end

      case result do
        {:nonsequential_direction, _} -> false
        {:nongradual_difference, _} -> false
        _ -> true
      end
    end)
  end
end
