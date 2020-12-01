  defmodule Advent2020.Day1 do
    import Helpers.Shared, only: [log: 1]

    def part1(input) do
      log("Running 2020-1-P1-InputList")
      log("Input length: #{length(input)}")
      valid_nums = input
      |> Enum.map(&String.to_integer/1)
      |> Enum.reject(&(&1 > 2020))

      log("Filtered input #{length(valid_nums)}")
      try do
        for num <- valid_nums do
          case Enum.find(valid_nums, fn other -> other + num == 2020 end) do
            nil ->
              log("#{num} did not sum to 2020 with any numbers")
              nil
            matching_val ->
              log("#{num}+#{matching_val}=2020, returning product")
              throw(matching_val * num)
          end
        end
      catch
        result -> result
      end
    end

    def part1_stream(input_stream) do
      log("Running 2020-1-P1-InputStream")
      "Not implemented"
    end

    def part2(input) do
      log("Running 2020-1-P2-InputList")
      "Not implemented"
    end

    def part2_stream(input_stream) do
      log("Running 2020-1-P2-InputStream")
      "Not implemented"
    end
  end
