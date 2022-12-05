defmodule Advent2022.Day4 do
  require Logger

  def part1(input) do
    Logger.info("Running 2022-4-P1-InputList")
    input
    |> IO.inspect(label: :input_for_day1, pretty: true)
    |> Enum.map(&convert_line_to_ranges/1)
    |> Enum.count(&is_subset?/1)
  end

  defp convert_line_to_ranges(elf_pair_string) do
    elf_pair_string
    |> String.split(",")
    |> Enum.map(&convert_elf_assignment_to_range/1)
  end

  defp convert_elf_assignment_to_range(elf_assignment) do
    [section_start, section_end] = elf_assignment |> String.split("-")
    Range.new(String.to_integer(section_start), String.to_integer(section_end))
  end

  defp is_subset?([elf1_assignment_range, elf2_assignment_range]) do
    elf1_assignment_set = MapSet.new(elf1_assignment_range)
    elf2_assignment_set = MapSet.new(elf2_assignment_range)

    MapSet.subset?(elf1_assignment_set, elf2_assignment_set) || MapSet.subset?(elf2_assignment_set, elf1_assignment_set)
  end

  def part2(input) do
    Logger.info("Running 2022-4-P2-InputList")
    input
    |> IO.inspect(label: :input_for_day2, pretty: true)
    |> Enum.map(&convert_line_to_ranges/1)
    |> Enum.count(&is_overlapping?/1)
  end

  defp is_overlapping?([elf1_assignment_range, elf2_assignment_range]) do
    !Range.disjoint?(elf1_assignment_range, elf2_assignment_range)
  end
end
