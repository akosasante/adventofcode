defmodule Advent2022.Day1 do
  require Logger

  def part1(input) do
    Logger.info("Running 2022-1-P1-InputList")
    # Attempt #1
    ## -- loop through list and split on newline/empty string element
    ###### Could do chunk_by/1 but that leaves the newline elements as their own sublists too :/
    ## -- loop through list of lists and sum up each group
    ## -- get max
    ##    ips        average  deviation         median         99th %
    ##  7.11 K      140.72 μs   ±288.75%      111.58 μs      497.91 μs
    input
    |> Enum.chunk_while([], fn elem, acc ->
      if elem == "", do: {:cont, acc, []}, else: {:cont, [String.to_integer(elem) | acc]}
    end, fn acc -> {:cont, acc} end)
    |> Enum.map(fn sublist -> Enum.sum(sublist) end)
    |> Enum.max()

    # Attempt #2
    ## -- let's try to do it in one iteration of the list with reduce
    ##   ips        average     deviation         median        99th %
    ##   9.46 K     105.74 μs   ±352.62%          92.01 μs      204.35 μs
    ## Surprisingly this was slower? but not by much

#    {_, maxElfCalories} = input
#    |> Enum.reduce({0, 0}, fn calories, {currentElfSum, maxElfSum} ->
#      if calories == "" do
#        maxElfSum = max(maxElfSum, currentElfSum)
#        {0, maxElfSum}
#      else
#        calories = String.to_integer(calories)
#        currentElfSum = currentElfSum + calories
#        {currentElfSum, maxElfSum}
#      end
#    end)
#    maxElfCalories
  end

  def part2(input) do
    Logger.info("Running 2022-1-P2-InputList")
    input
    |> Enum.chunk_while([], fn elem, acc ->
      if elem == "", do: {:cont, acc, []}, else: {:cont, [String.to_integer(elem) | acc]}
    end, fn acc -> {:cont, acc} end)
    |> Enum.map(fn sublist -> Enum.sum(sublist) end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.sum()
  end
end
