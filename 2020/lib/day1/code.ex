defmodule Advent2020.Day1 do
  import Helpers.Shared, only: [log: 1]

  def part1(input) do
    log("Running 2020-1-P1-InputList")
    # Enum.find soln ~ 350us
    valid_nums =
      input
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

    integer_stream =
      input_stream
      |> Stream.map(&String.to_integer/1)

    {val1, val2} =
      stream_two_values_for_sum(integer_stream, 2020)
      |> Enum.to_list()
      |> List.first()

    val1 * val2
  end

  def part2(input) do
    log("Running 2020-1-P2-InputList")

    valid_nums =
      input
      |> Enum.map(&String.to_integer/1)
      #                   |> calculate_expense(0)
      |> Enum.reject(&(&1 > 2020))

    try do
      # For each value, up to len(input), run get_two_values, which also loops through list. So n^2 ?
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
        log("Resulting triplet=#{inspect({val1, val2, val3})}")
        val1 * val2 * val3
    end
  end

  def part2_optimized(input) do
    log("Running 2020-1-P2-InputOptimized")

    # From: https://github.com/evantravers/adventofcode/blob/master/2020/elixir/lib/day01/expense_report.ex. I think this is much slower because we're looping through n^3 times
    list_of_ints = Enum.map(input, &String.to_integer/1)

    for int1 <- list_of_ints,
        int2 <- list_of_ints,
        int3 <- list_of_ints do
      {int1, int2, int3}
    end
    |> Enum.find(fn {int1, int2, int3} -> int1 + int2 + int3 == 2020 end)
    |> Tuple.to_list()
    |> Enum.reduce(&(&1 * &2))
  end

  def part2_stream(input_stream) do
    log("Running 2020-1-P2-InputStream")

    integer_stream =
      input_stream
      |> Stream.map(&String.to_integer/1)

    {val1, val2, val3} =
      integer_stream
      |> Stream.map(fn val1 ->
        log("Num=#{val1}, looking for two values that sum to #{2020 - val1}")

        vals =
          stream_two_values_for_sum(integer_stream, 2020 - val1)
          |> Enum.to_list()
          |> List.first()

        case vals do
          nil -> nil
          {val2, val3} -> {val1, val2, val3}
        end
      end)
      |> Stream.reject(&is_nil/1)
      |> Enum.to_list()
      |> List.first()

    val1 * val2 * val3
  end

  #    https://github.com/ericgroom/advent2020/blob/master/lib/days/day_1.ex
  #    @anomoly_sum 2020
  #
  #    def find_expense_anomoly items do
  #      pairs = permutations_exluding_self(items)
  #
  #      {expense_one, expense_two} = Enum.find(pairs, fn {x, y} ->
  #        x + y == @anomoly_sum
  #      end)
  #
  #      expense_one * expense_two
  #    end
  #
  #    def find_other_anomoly items do
  #      items_set = MapSet.new(items)
  #      pairs = permutations_exluding_self(items)
  #
  #      {expense_one, expense_two} = Enum.find(pairs, fn {x, y} ->
  #        counterpart = @anomoly_sum - x - y
  #        MapSet.member?(items_set, counterpart)
  #      end)
  #
  #      expense_three = @anomoly_sum - expense_one - expense_two
  #      expense_one * expense_two * expense_three
  #    end
  #
  #    defp permutations_exluding_self items do
  #      enumerated_items = Enum.with_index(items)
  #      enumerated_items
  #      |> Enum.flat_map(fn {item, index} ->
  #        Enum.map(enumerated_items, fn {second_item, second_index} ->
  #          if index == second_index, do: nil, else: {item, second_item}
  #        end)
  #      end)
  #      |> Enum.filter(fn item -> item != nil end)
  #    end

  @spec get_two_values_for_sum(list(String.t()), non_neg_integer()) ::
          {non_neg_integer, non_neg_integer}
  # Loop through list once to make the map + Loop through list at most once to get sums
  defp get_two_values_for_sum(list, desired_sum) do
    valid_num_map =
      list
      |> Enum.map(fn val -> {val, String.to_integer(val)} end)
      |> Map.new()

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

  defp stream_two_values_for_sum(stream, desired_sum) do
    stream
    |> Stream.flat_map(fn num1 ->
      stream
      |> Stream.map(fn num2 ->
        if num1 + num2 == desired_sum do
          log("#{num1}+#{num2}==#{desired_sum}")
          {num1, num2}
        end
      end)
      |> Stream.reject(&is_nil/1)
    end)
  end

  # FROM https://github.com/venkatesh73/aoc/blob/master/2020/elixir/expense_report_adv.ex (quite fast, compared to mine :) )
  #    def calculate_expense([number | expenses], result) do
  #      remaining =
  #        Enum.reduce(expenses, [], fn rest, result ->
  #          if (rest + number) < 2020, do: [rest | result], else: result
  #        end)
  #
  #      computed =
  #        Enum.reduce_while(remaining, 0, fn operand, result ->
  #          next_half = 2020 - (number + operand)
  #          if Enum.find_value(expenses, fn second_operand ->
  #            second_operand == next_half
  #          end) do
  #            {:halt, number * operand * next_half}
  #          else
  #            {:cont, result}
  #          end
  #        end)
  #
  #      if computed > 0 do
  #        calculate_expense([], computed)
  #      else
  #        calculate_expense(expenses, result)
  #      end
  #
  #    end
  #
  #    def calculate_expense([], result), do: result
end
