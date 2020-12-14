  defmodule Advent2020.Day14 do
    import Helpers.Shared, only: [log: 1]

    def part1(input) do
      log("Running 2020-14-P1-InputList")
      {_, _, memory_map} = Enum.reduce(input, {nil, nil, %{}}, fn curr_line, {or_mask, and_mask, memory} ->
        case curr_line do
          "mask = " <> mask_string ->
            {get_or_mask(mask_string), get_and_mask(mask_string), memory}
          memory_string ->
            [index, decimal_value] = Regex.run(~r/^mem\[(\d+)\] = (\d+)$/, memory_string, capture: :all_but_first)
            binary_value = String.to_integer(decimal_value)
            value_to_store = Bitwise.bor(binary_value, or_mask) - Bitwise.band(binary_value, and_mask)
            {or_mask, and_mask, Map.put(memory, index, value_to_store)}
        end
      end)

      memory_map
      |> Map.values()
      |> Enum.sum()
    end

    def part1_optimized(input) do
      log("Running 2020-14-P1-InputListOptimized")
      "Not implemented"
    end

    def part1_stream(input_stream) do
      log("Running 2020-14-P1-InputStream")
      "Not implemented"
    end

    def part2(input) do
      log("Running 2020-14-P2-InputList")
      "Not implemented"
    end

    def part2_optimized(input) do
      log("Running 2020-14-P2-InputListOptimized")
      "Not implemented"
    end

    def part2_stream(input_stream) do
      log("Running 2020-14-P2-InputStream")
      "Not implemented"
    end

    def get_and_mask(mask_string) do
      mask_string
      |> String.replace("1", "X")
      |> String.replace("0", "1")
      |> String.replace("X", "0")
      |> String.to_integer(2)
    end

    def get_or_mask(mask_string) do
      mask_string
      |> String.replace("X", "0")
      |> String.to_integer(2)
    end
  end
