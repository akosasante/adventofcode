defmodule Advent2022.Day3 do
  require Logger

  def part1(input) do
    Logger.info("Running 2022-3-P1-InputList")
    input
    |> IO.inspect(label: :input_for_day1, pretty: true)
    |> Enum.map(&find_incorrectly_sorted_item/1)
    |> Enum.map(&convert_item_to_value/1)
    |> Enum.sum()
  end

  defp find_incorrectly_sorted_item(rucksack_str) do
    rucksack_size = String.length(rucksack_str)
    halfway_point = div(rucksack_size, 2)
    {compartmentA, compartmentB} = String.split_at(rucksack_str, halfway_point)
    compartmentASet = MapSet.new(String.to_charlist(compartmentA))
    compartmentBSet = MapSet.new(String.to_charlist(compartmentB))

    MapSet.intersection(compartmentASet, compartmentBSet) |> Enum.at(0)
  end

  defp convert_item_to_value(item) when is_binary(item) do
    # returns the first byte of the binary string: https://www.erlang.org/doc/man/binary.html#first-1
    # use because we're certain you are working with ASCII (ie single byte code points)
    ### Might not even need this if we get previous function to return the ascii value already
    convert_item_to_value(:binary.first(item))
  end

  defp convert_item_to_value(ascii_value) when is_integer(ascii_value) and ascii_value <= 90 and ascii_value >= 65, do: ascii_value - 38
  defp convert_item_to_value(ascii_value) when is_integer(ascii_value) and ascii_value <= 122 and ascii_value >= 97, do: ascii_value - 96
  defp convert_item_to_value(invalid_value_or_item) do
    raise "Could not parse item to its ascii value: #{inspect(invalid_value_or_item)}"
  end

  def part2(input) do
    Logger.info("Running 2022-3-P2-InputList")

    input
    |> IO.inspect(label: :input_for_day2, pretty: true)
    |> Enum.chunk_every(3)
    |> Enum.map(&find_badge_in_elf_group/1)
    |> Enum.map(&convert_item_to_value/1)
    |> Enum.sum()
  end

  defp find_badge_in_elf_group(elf_group) do
    map_sets = Enum.map(elf_group, fn elf_rucksack -> MapSet.new(String.to_charlist(elf_rucksack)) end)
#    IO.inspect("Elf group: #{inspect(elf_group)} | Mapsets: #{inspect(map_sets)}")
    Enum.reduce(map_sets, fn map_set, prev_intersection ->
#      IO.inspect({map_set, prev_intersection})
      MapSet.intersection(map_set, prev_intersection)
    end)
#    |> IO.inspect(label: :answer)
    |> Enum.at(0)
  end
end
