defmodule Advent2020.Day13 do
  import Helpers.Shared, only: [log: 1]

  def part1(input) do
    log("Running 2020-13-P1-InputList")
    [arrived_at_airport_at, bus_times] = input
    arrived_at_airport_at = String.to_integer(arrived_at_airport_at)

    bus_ids =
      bus_times
      |> String.split(",")
      |> Enum.reject(&(&1 == "x"))
      |> Enum.map(&String.to_integer/1)

    {time_next_bus_arrives, bus_id} =
      Stream.unfold({arrived_at_airport_at, nil}, fn
        {time_to_check, nil} ->
          case Enum.find(bus_ids, &is_arriving?(&1, time_to_check)) do
            nil -> {nil, {time_to_check + 1, nil}}
            bus_id -> {{time_to_check, bus_id}, nil}
          end

        _ ->
          nil
      end)
      |> Enum.to_list()
      |> List.last()

    (time_next_bus_arrives - arrived_at_airport_at) * bus_id
  end

  def part1_optimized(input) do
    log("Running 2020-13-P1-InputListOptimized")
    "Not implemented"
  end

  def part1_stream(input_stream) do
    log("Running 2020-13-P1-InputStream")
    "Not implemented"
  end

  def part2(input) do
    log("Running 2020-13-P2-InputList")

    # with numA, numB: find the first value that works. so multiples of the larger of the two and check each time if it matches the criteria
    # once we know the smallest num that matches for numA and numB, check if it works for numC. If not, start iterating at values of smallest_num + numA*numB
    # once we know the smallest num that matches for numA, numB, numC, same as above (check for numD, then iterate by LCM)
    [_, bus_times] = input

    sorted_bus_schedules =
      bus_times
      |> String.split(",")
      |> Enum.with_index()
      |> Enum.reject(fn {letter, _} -> letter == "x" end)
      |> Enum.map(fn {bus_id, offset} -> {String.to_integer(bus_id), offset} end)
      |> Enum.sort(fn {bus_id_1, _}, {bus_id_2, _} -> bus_id_1 >= bus_id_2 end)
      |> find_p2_timestamp()
  end

  def part2_optimized(input) do
    log("Running 2020-13-P2-InputListOptimized")
    "Not implemented"
  end

  def part2_stream(input_stream) do
    log("Running 2020-13-P2-InputStream")
    "Not implemented"
  end

  defp is_arriving?(bus_id, timestamp), do: rem(timestamp, bus_id) == 0

  def find_p2_timestamp(sorted_bus_schedules) do
    {max_bus_id, max_offset} = first_schedule = List.first(sorted_bus_schedules)

    {_, _, matching_num} =
      Enum.reduce(
        Enum.slice(sorted_bus_schedules, 1..-1),
        {[first_schedule], max_bus_id, max_bus_id},
        fn curr_bus_schedule, {buses_to_check, increment_by, starting_number} = acc ->
          IO.puts("Checking for #{inspect(curr_bus_schedule)}, acc=#{inspect(acc)}")

          bus_schedules_to_check =
            [curr_bus_schedule | buses_to_check] |> IO.inspect(label: :bus_schedules_to_check)

          next_starting_number =
            iterate_over_multiples_and_find_first_match(
              bus_schedules_to_check,
              starting_number,
              increment_by
            )
            |> IO.inspect(label: :next_starting_number)

          next_increment_number =
            lowest_common_multiple(bus_schedules_to_check)
            |> IO.inspect(label: :next_increment_number)

          {bus_schedules_to_check, next_increment_number, next_starting_number}
        end
      )

    matching_num - max_offset
  end

  def iterate_over_multiples_and_find_first_match(
        bus_schedules,
        starting_number,
        increment_number
      ) do
    Stream.unfold({starting_number, false}, fn
      {time_to_check, false} ->
        if matches_p2_criteria?(bus_schedules, time_to_check) do
          {time_to_check, {time_to_check, true}}
        else
          {nil, {time_to_check + increment_number, false}}
        end

      {_, true} ->
        nil
    end)
    |> Enum.to_list()
    |> List.last()
  end

  def matches_p2_criteria?(bus_schedules, time_to_check) do
    IO.puts("Checking if matches p2 criteria #{inspect({bus_schedules, time_to_check})}")
    {max_bus_id, max_offset} = Enum.max_by(bus_schedules, fn {bus_id, _} -> bus_id end)

    Enum.reduce_while(bus_schedules, true, fn {bus_id, offset}, _ ->
      if bus_id == max_bus_id do
        # we already know the biggest number goes into the time_to_check; that's the only time we'd call this method
        {:cont, true}
      else
        # check all the other schedules to see if they go into the appropriate number (using the offset) with a remainder of 0
        matches? = rem(time_to_check - (max_offset - offset), bus_id) == 0

        if matches? do
          {:cont, true}
        else
          {:halt, false}
        end
      end
    end)
  end

  def lowest_common_multiple(bus_schedules) do
    # because our input is coprimes, just multiply the bus ids together
    Enum.reduce(bus_schedules, 1, fn {bus_id, _}, product -> product * bus_id end)
  end
end
