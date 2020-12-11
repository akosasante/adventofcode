#defmodule Advent2020.Day11.Position


defmodule Advent2020.Day11 do
    import Helpers.Shared, only: [log: 1]
    @check_positions [{-1, -1}, {-1, 0}, {-1, 1}, {0, -1}, {0, 1}, {1, -1}, {1, 0}, {1, 1}]

    def part1(input) do
      log("Running 2020-11-P1-InputList")
      input = Enum.map(input, &String.graphemes/1)


      {num_generations_until_stable, stable_waiting_room} =
        Stream.unfold({input, 0, false}, fn
          {waiting_room, 0, false} ->
            IO.puts "============GENERATION 0============"
#            print(waiting_room)
            {{0, waiting_room}, {waiting_room, 1, false}}
          {waiting_room, generation, false} ->
            IO.puts "============GENERATION #{generation}============"
            {new_generation, is_match} = run_generation(waiting_room, "part1")
#            print(new_generation)
            IO.puts("matches previous? #{is_match}")
            {{generation, new_generation}, {new_generation, generation + 1, is_match}}
          {waiting_room, generation, true} -> nil
        end)
        |> Enum.to_list()
        |> List.last()

      num_seats_occupied = Enum.flat_map(stable_waiting_room, &(&1)) |> Enum.count(&(&1 == "#"))
    end

    def part1_optimized(input) do
      log("Running 2020-11-P1-InputListOptimized")
      "Not implemented"
    end

    def part1_stream(input_stream) do
      log("Running 2020-11-P1-InputStream")
      "Not implemented"
    end

    def part2(input) do
      log("Running 2020-11-P2-InputList")
      input = Enum.map(input, &String.graphemes/1)


      {num_generations_until_stable, stable_waiting_room} =
        Stream.unfold({input, 0, false}, fn
          {waiting_room, 0, false} ->
            IO.puts "============GENERATION 0============"
            print(waiting_room)
            {{0, waiting_room}, {waiting_room, 1, false}}
          {waiting_room, generation, false} ->
            IO.puts "============GENERATION #{generation}============"
            {new_generation, is_match} = run_generation(waiting_room, "part2")
            print(new_generation)
            IO.puts("matches previous? #{is_match}")
            {{generation, new_generation}, {new_generation, generation + 1, is_match}}
          {waiting_room, generation, true} -> nil
        end)
        |> Enum.to_list()
        |> List.last()

      num_seats_occupied = Enum.flat_map(stable_waiting_room, &(&1)) |> Enum.count(&(&1 == "#"))
    end

    def part2_optimized(input) do
      log("Running 2020-11-P2-InputListOptimized")
      "Not implemented"
    end

    def part2_stream(input_stream) do
      log("Running 2020-11-P2-InputStream")
      "Not implemented"
    end

    defp run_generation(waiting_room, part) do
      {_, new_waiting_room} = Enum.reduce(waiting_room, {0, []}, fn row, {curr_row, new_waiting_room} ->
        new_row = Enum.with_index(row) |> Enum.map(fn {position, curr_column} ->
          check_neighbours_and_return_new_cell(position, curr_row, curr_column, waiting_room, part)
        end)
        {curr_row + 1, [new_row | new_waiting_room]}
      end)

      new_waiting_room = Enum.reverse(new_waiting_room)
      {new_waiting_room, new_waiting_room == waiting_room}
    end

    defp check_neighbours_and_return_new_cell("L", row, col, waiting_room, part) do
      case surrounding_occupied_seats(part, waiting_room, row, col) do
        0 -> "#"
        _ -> "L"
      end
    end

    defp check_neighbours_and_return_new_cell("#", row, col, waiting_room, "part1" = part) do
      case surrounding_occupied_seats(part, waiting_room, row, col) do
        n when n >= 4 -> "L"
        _ -> "#"
      end
    end

    defp check_neighbours_and_return_new_cell("#", row, col, waiting_room, "part2" = part) do
      case surrounding_occupied_seats(part, waiting_room, row, col) do
        n when n >= 5 -> "L"
        _ -> "#"
      end
    end

    defp check_neighbours_and_return_new_cell(position, _, _, _, _), do: position

    defp surrounding_occupied_seats(part, waiting_room, row, col) do
      max_row = length(waiting_room) - 1
      max_col = length(hd(waiting_room)) - 1

      for {check_row, check_col} <- @check_positions, reduce: 0 do
        sum_of_occupied_seats ->
#          IO.puts "Current sum: #{sum_of_occupied_seats}"
          check_for_occupied_seats(part, waiting_room, sum_of_occupied_seats, row, check_row, max_row, col, check_col, max_col)
      end
    end

    defp check_for_occupied_seats("part1", waiting_room, sum_of_occupied_seats, row, check_row, max_row, col, check_col, max_col) do
      if (row + check_row) in 0..max_row and (col + check_col) in 0..max_col do
        case cell_at_position(waiting_room, row + check_row, col + check_col) do
          "#" -> sum_of_occupied_seats + 1
          _ -> sum_of_occupied_seats
        end
      else
        sum_of_occupied_seats
      end
    end

    defp check_for_occupied_seats("part2", waiting_room, sum, row, check_row, max_row, col, check_col, max_col) do
#      IO.puts "Checking (#{row}, #{col}) in direction (#{check_row}, #{check_col}). Starting sum = #{sum}"
      Stream.unfold({sum, row + check_row, col + check_col, false}, fn
        {sum_of_occupied_seats, row_to_check, col_to_check, false} when row_to_check in 0..max_row and col_to_check in 0..max_col ->
#          :timer.sleep(1500)
#          IO.puts("Checking (#{row_to_check}, #{col_to_check})")
          case cell_at_position(waiting_room, row_to_check, col_to_check) do
            "#" ->
#              IO.puts("Occupied seat seen at (#{row_to_check}, #{col_to_check})")
              {sum_of_occupied_seats + 1, {sum_of_occupied_seats, row_to_check + check_row, col_to_check + check_col, true}}
            "L" ->
#              IO.puts("Unoccupied seat seen at (#{row_to_check}, #{col_to_check})")
              {sum_of_occupied_seats, {sum_of_occupied_seats, row_to_check + check_row, col_to_check + check_col, true}}
            _ ->
#              IO.puts("Floor seen, continuing")
              {sum_of_occupied_seats, {sum_of_occupied_seats, row_to_check + check_row, col_to_check + check_col, false}}
          end
        _ ->  nil
      end)
      |> Enum.to_list()
      |> case do
        [] -> sum
        list ->
#          IO.inspect(list, label: :results_from_occupy_check, charlists: :as_lists)
          List.last(list)
       end
#       |> IO.inspect(label: :res)
    end

    defp cell_at_position(waiting_room, row, col) do
      waiting_room
      |> Enum.at(row)
      |> Enum.at(col)
    end

    defp print(waiting_room) do
      :timer.sleep(1000)

      color_map = %{
        "#" => IO.ANSI.light_blue_background(),
        "L" => IO.ANSI.light_yellow_background() <> IO.ANSI.black(),
        "." => IO.ANSI.light_magenta_background() <> IO.ANSI.blink_slow()
      }
      string_room =
        Enum.map_join(waiting_room, "\n", fn row ->
          Enum.map(row, fn l -> Map.get(color_map, l) <> l <> IO.ANSI.reset() end)
        end)

      log(string_room)
    end
  end
