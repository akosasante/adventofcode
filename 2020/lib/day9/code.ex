  defmodule Advent2020.Day9 do
    import Helpers.Shared, only: [log: 1]

    @preamble_length 25

    def part1(input) do
      log("Running 2020-9-P1-InputList")
      input = Enum.map(input, &String.to_integer/1)
      {first_25_list, rest} = Enum.split(input, @preamble_length)

      traverse_and_sum(first_25_list, rest)
    end

    def part1_optimized(input) do
      log("Running 2020-9-P1-InputListOptimized")
      "Not implemented"
    end

    def part1_stream(input_stream) do
      log("Running 2020-9-P1-InputStream")
      "Not implemented"
    end

    def part2(input) do
      log("Running 2020-9-P2-InputList")
      sum_from_part_1 = 14360655
#      sum_from_part_1 = part1(input)
      input = Enum.map(input, &String.to_integer/1)
      {min, max} = traverse_and_find_sum_set(input, sum_from_part_1)
      min + max
    end

    def part2_optimized(input) do
      log("Running 2020-9-P2-InputListOptimized")
      "Not implemented"
    end

    def part2_stream(input_stream) do
      log("Running 2020-9-P2-InputStream")
      "Not implemented"
    end

    defp traverse_and_sum([_ | rest_of_preamble] = preamble, [next_number | rest_of_list]) do
      log("Checking for sums of #{next_number} in #{inspect preamble}")
      if has_sum_in_preamble?(next_number, preamble) do
        log("Sum was found.")
        preamble = rest_of_preamble ++ [next_number]
        log("New map=#{inspect preamble}")

        traverse_and_sum(preamble, rest_of_list)

      else
        log("#{next_number} had no sums in past #{@preamble_length} elems. Returning.")
        next_number
      end
    end

    defp has_sum_in_preamble?(number, preamble) do
      preamble_map = MapSet.new(preamble)
      Enum.reduce_while(preamble_map, false, fn val_to_check, has_sum? ->
        if MapSet.member?(preamble_map, number - val_to_check) do
          log("Map had sum of #{number} (#{val_to_check} + #{number - val_to_check})")
          {:halt, true}
        else
          log("Map does not have additive for #{val_to_check}, continue checking")
          {:cont, has_sum?}
        end
      end)
    end

    defp traverse_and_find_sum_set(list, target) do
      # traverrse thtrough each eleem in the list (reduce)
      # at each elem we want to grab the whole list starting from that eleem (acc tracks starting index)
      # put that list in another reducee or recursivee to check sum
      # sum is checked against targeet by adding successively moree from th elist and doing sum
      Enum.reduce_while(list, 0, fn _, index ->
        log("checking index #{index} of list.")
        [first | rest] = Enum.slice(list, index, length(list))
        if first > target do
          log("starting element is too big, just skip to next iteration")
          {:cont, index + 1}
        else
          case find_contiguous_sum([first], rest, target) do
            nil ->
              log("find_contiguous_sum failed to find sum starting at #{index}, try next")
              {:cont, index + 1}
            sum_list ->
              log("found sum! #{inspect sum_list}")
              {:halt, Enum.min_max(sum_list)}
          end
        end
      end)
    end

    defp find_contiguous_sum(contiguous_list, [], target) do
      sum = Enum.sum(contiguous_list)
      cond do
        sum == target ->
          log("Found contiguous sum, returning")
          contiguous_list
        sum > target ->
          log("Contiguous sum got too big, no need to continue, return nil")
          nil
        true ->
          log("did not find contiguous sum and reached end of list, return nil")
          nil
      end
#
#      if contiguous_list_sums_to_target?(contiguous_list, target) do
#        log("Found contiguous sum, returning")
#        contiguous_list
#      else
#        log("did not find contiguous sum and reached end of list, return nil")
#        nil
#      end
    end

    defp find_contiguous_sum(contiguous_list, [next | rest_of_list], target) do
      sum = Enum.sum(contiguous_list)
      cond do
        sum == target ->
          log("Found contiguous sum, returning")
          contiguous_list
        sum > target ->
          log("Contiguous sum got too big, no need to continue, return nil")
          nil
        true ->
          log("did not find contiguous sum")
          contiguous_list = contiguous_list ++ [next]
          log("new contiguous list = #{inspect(contiguous_list, charlists: :as_lists)}")
          find_contiguous_sum(contiguous_list, rest_of_list, target)
      end
#      if contiguous_list_sums_to_target?(contiguous_list, target) do
#        log("Found contiguous sum, returning")
#        contiguous_list
#      else
#        log("did not find contiguous sum")
#        contiguous_list = contiguous_list ++ [next]
#        log("new contiguous list = #{inspect(contiguous_list, charlists: :as_lists)}")
#        find_contiguous_sum(contiguous_list, rest_of_list, target)
#      end
    end

#    defp contiguous_list_sums_to_target?(contiguous_list, target) do
#      log("Checking if sum(#{inspect(contiguous_list, charlists: :as_lists)}) == #{target}")
#      Enum.sum(contiguous_list)
#    end
  end
