  defmodule Advent2020.Day14 do
    import Helpers.Shared, only: [log: 1]

    def part1(input) do
      log("Running 2020-14-P1-InputList")
      {_, _, memory_map} = Enum.reduce(input, {nil, nil, %{}}, fn curr_line, {or_mask, and_mask, memory} ->
        case curr_line do
          "mask = " <> mask_string ->
            {get_or_mask(mask_string), get_and_mask(mask_string), memory}
          memory_string ->
            [memory_address, decimal_value] = Regex.run(~r/^mem\[(\d+)\] = (\d+)$/, memory_string, capture: :all_but_first)
            binary_value = String.to_integer(decimal_value)
            value_to_store = Bitwise.bor(binary_value, or_mask) - Bitwise.band(binary_value, and_mask)
            {or_mask, and_mask, Map.put(memory, memory_address, value_to_store)}
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
      {_, _, memory_map} = Enum.reduce(input, {nil, [], %{}}, fn curr_line, {static_mask, floating_masks, memory} ->
        case curr_line do
          "mask = " <> mask_string ->
            {get_static_mask(mask_string), get_variations_of_mask(mask_string), memory}

          memory_string ->
            [memory_address, decimal_value] = Regex.run(~r/^mem\[(\d+)\] = (\d+)$/, memory_string, capture: :all_but_first)

            memory_address_after_static_mask = String.to_integer(memory_address) |> Bitwise.bor(static_mask)
            decimal_value = String.to_integer(decimal_value)

            updated_memory = Enum.reduce(floating_masks, memory, fn mask, memory_map ->
              new_address = Bitwise.bor(memory_address_after_static_mask, mask) - Bitwise.band(memory_address_after_static_mask, mask)
              log("Putting #{decimal_value} at #{new_address}")
              Map.put(memory_map, new_address, decimal_value)
            end)

            {static_mask, floating_masks, updated_memory}
        end
      end)

      memory_map
      |> Map.values()
      |> Enum.sum()
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

    def get_variations_of_mask(mask_string) do
      mask = String.replace(mask_string, "1", "0")
      num_floating_bits = mask |> String.graphemes |> Enum.count(&(&1 == "X"))
      num_variations = Bitwise.bsl(1, num_floating_bits)

      Enum.map(0..num_variations - 1, fn decimal_variation ->
        binary_variation_digits = Integer.to_string(decimal_variation, 2) |> String.pad_leading(num_floating_bits, "0") |> String.graphemes
        mask_digits = String.graphemes(mask)

        {mask_variation, _} = Enum.reduce(mask_digits, {"", binary_variation_digits}, fn mask_digit, {new_mask, floating_bits} ->
          case mask_digit do
            "X" -> {new_mask <> List.first(floating_bits), Enum.slice(floating_bits, 1..-1)}
            num -> {new_mask <> num, floating_bits}
          end
        end)
        String.to_integer(mask_variation, 2)
      end)
    end

    defp get_static_mask(mask_string) do
      mask_string
      |> String.replace("X", "0") #ignore x's for now
      |> String.to_integer(2)
    end
  end
