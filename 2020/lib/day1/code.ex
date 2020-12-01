  defmodule Advent2020.Day1 do
    import Helpers.Shared, only: [log: 1]

    def part1(input) do
      log("Running 2020-1-P1-InputList")
      # Enum.find soln ~ 350us
      valid_nums = input
      |> Enum.map(&String.to_integer/1)
      |> Enum.reject(&(&1 > 2020))

      try do
        for num <- valid_nums do
          case Enum.find(valid_nums, fn other -> other + num == 2020 end) do
            nil ->
              nil
            matching_val ->
              throw(matching_val * num)
          end
        end
      catch
        result -> result
      end
    end

    def part1_optimized(input) do
      # Map soln ~ 390us
      {num1, num2} = get_two_values_for_sum(input, 2020)
      num1 * num2
    end

    def part1_stream(input_stream) do
      log("Running 2020-1-P1-InputStream")
#      list = Enum.to_list(input_stream)
#
#      result = input_stream
#      |> Stream.map(&String.to_integer/1)
#      |> Stream.reject(&(&1 > 2020))
#      |> Stream.drop_while(fn num -> !Enum.find(list, fn n -> String.to_integer(n) + num == 2020 end) end)
#      |> Enum.to_list()
#
#      IO.inspect(result)
      "Not implemented"
    end

    def part2(input) do
      log("Running 2020-1-P2-InputList")
      valid_nums = input
                   |> Enum.map(&String.to_integer/1)
                   |> Enum.reject(&(&1 > 2020))

      try do
        for val1 <- valid_nums do
          log("Num=#{val1}, looking for two values that sum to #{2020 - val1}")
          case get_two_values_for_sum(input, 2020 - val1) do
            {val2, val3} -> throw({val1, val2, val3})
            nil -> nil
          end
        end
        nil
      catch
        {val1, val2, val3} = result ->
          log("Resulting triplet=#{inspect {val1, val2, val3}}")
          val1 * val2 * val3
      end
    end

    def part2_optimized(input_stream) do
      log("Running 2020-1-P2-InputOptimized")
      "Not implemented"
    end

    def part2_stream(input_stream) do
      log("Running 2020-1-P2-InputStream")
      "Not implemented"
    end

    @spec get_two_values_for_sum(list(String.t()), non_neg_integer()) :: {non_neg_integer, non_neg_integer}
    defp get_two_values_for_sum(list, desired_sum) do
      valid_num_map =
        list
        |> Enum.map(fn val -> {val, String.to_integer(val)} end)
        |> Map.new

        try do
          for num <- list do
            val = String.to_integer(num)
            case Map.get(valid_num_map, "#{desired_sum - val}") do
              nil ->
                nil
              matching_val ->
                throw({matching_val, val})
            end
          end
          # We got through for loop without throwing, meaning no matches, return nil
          nil
      catch
          result ->
            result
        end
      end
  end
