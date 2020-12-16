  defmodule Advent2020.Day15 do
    import Helpers.Shared, only: [log: 1]

    def part1(input) do
      log("Running 2020-15-P1-InputList")
      starting_numbers = String.split(hd(input), ",")
      Stream.iterate(starting_numbers, &play_turns/1)
      |> Enum.at(30000000 - Enum.count(starting_numbers) + 1)
      |> Map.get(:last_number)
    end

    def part1_optimized(input) do
      log("Running 2020-15-P1-InputListOptimized")
      "Not implemented"
    end

    def part1_stream(input_stream) do
      log("Running 2020-15-P1-InputStream")
      "Not implemented"
    end

    def part2(input) do
      log("Running 2020-15-P2-InputList")
      "Not implemented"
    end

    def part2_optimized(input) do
      log("Running 2020-15-P2-InputListOptimized")
      "Not implemented"
    end

    def part2_stream(input_stream) do
      log("Running 2020-15-P2-InputStream")
      "Not implemented"
    end

    defp play_turns(starting_numbers) when is_list(starting_numbers) do
      Enum.each(Enum.with_index(starting_numbers), fn {num, index} ->
        log("======TURN #{index + 1}======")
        log("++++++ELF CALLS OUT STARTING NUMBER #{num}++++++++")
      end)
      everything_but_last = Enum.slice(starting_numbers, 0..-2)
      starting_map = Enum.with_index(everything_but_last) |> Enum.map(fn {number, turn} -> {number, turn + 1} end) |> Map.new()
      %{turn: Enum.count(starting_numbers) + 1, last_number: List.last(starting_numbers), seen_before: MapSet.new(everything_but_last), last_turn_seen: starting_map}
    end

    defp play_turns(%{turn: turn, last_number: last_number, seen_before: seen_set, last_turn_seen: turn_map}) do
      log("======TURN #{turn}======")
      if MapSet.member?(seen_set, last_number) do
#        log("seen #{last_number} before")
        turn_last_seen = Map.get(turn_map, last_number)
        diff = turn - 1 - turn_last_seen
        turn_map = Map.put(turn_map, last_number, turn - 1)
        log("++++++ELF CALLS OUT #{diff} +++++++")
        %{turn: turn + 1, last_number: "#{diff}", seen_before: seen_set, last_turn_seen: turn_map}
      else
#        log("first time hearing #{last_number}")
        seen_set = MapSet.put(seen_set, last_number)
        turn_map = Map.put(turn_map, last_number, turn - 1)
        log("++++++ELF CALLS OUT 0 +++++++")
        %{turn: turn + 1, last_number: "0", seen_before: seen_set, last_turn_seen: turn_map}
      end
    end
  end
