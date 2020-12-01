  defmodule Advent2020.Day1 do
    import Helpers.Shared, only: [log: 1]

    def part1(input) do
      log("Running 2020-1-P1-InputList")
      valid_num_map =
        input
        |> Enum.map(fn val -> {val, String.to_integer(val)} end)
        |> Map.new

      try do
        for num <- input do
          val = String.to_integer(num)
          case Map.get(valid_num_map, 2020 - val) do
            nil ->
              nil
            matching_val ->
              throw(matching_val * val)
          end
        end
      catch
        result -> result
      end

#      valid_nums = input
#      |> Enum.map(&String.to_integer/1)
#      |> Enum.reject(&(&1 > 2020))
#
#      try do
#        for num <- valid_nums do
#          case Enum.find(valid_nums, fn other -> other + num == 2020 end) do
#            nil ->
#              nil
#            matching_val ->
#              throw(matching_val * num)
#          end
#        end
#      catch
#        result -> result
#      end
    end

    def part1_stream(input_stream) do
#      log("Running 2020-1-P1-InputStream")
#      input_stream
#      |> Stream.map(&String.to_integer/1)
#      |> Stream.reject(&(&1 > 2020))
#      |> Stream.take_while(fn num -> Enum.find() end)
#      "Not implemented"
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
