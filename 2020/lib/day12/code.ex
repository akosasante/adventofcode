  defmodule Advent2020.Day12 do
    import Helpers.Shared, only: [log: 1]
    @compass_directions ["N", "E", "S", "W"]

    def part1(input) do
      log("Running 2020-12-P1-InputList")
      {vertical_distance, horizontal_distance, _} =
        Enum.reduce(input, {0, 0, "E"}, fn instruction, curr_location ->
          move(curr_location, instruction)
        end)

      abs(vertical_distance) + abs(horizontal_distance)
    end

    def part1_optimized(input) do
      log("Running 2020-12-P1-InputListOptimized")
      "Not implemented"
    end

    def part1_stream(input_stream) do
      log("Running 2020-12-P1-InputStream")
      "Not implemented"
    end

    def part2(input) do
      log("Running 2020-12-P2-InputList")
      {vertical_distance, horizontal_distance, _, _} =
        Enum.reduce(input, {0, 0, 1, 10}, fn instruction, curr_location ->
          move(curr_location, instruction)
        end)

      abs(vertical_distance) + abs(horizontal_distance)
    end

    def part2_optimized(input) do
      log("Running 2020-12-P2-InputListOptimized")
      "Not implemented"
    end

    def part2_stream(input_stream) do
      log("Running 2020-12-P2-InputStream")
      "Not implemented"
    end

    defp move({vertical_position, horizontal_position, heading}, <<"N", distance::binary>>) do
      {vertical_position + String.to_integer(distance), horizontal_position, heading}
    end

    defp move({vertical_position, horizontal_position, heading}, <<"S", distance::binary>>) do
      {vertical_position - String.to_integer(distance), horizontal_position, heading}
    end

    defp move({vertical_position, horizontal_position, heading}, <<"E", distance::binary>>) do
      {vertical_position, horizontal_position + String.to_integer(distance), heading}
    end

    defp move({vertical_position, horizontal_position, heading}, <<"W", distance::binary>>) do
      {vertical_position, horizontal_position - String.to_integer(distance), heading}
    end

    defp move({vertical_position, horizontal_position, heading}, <<"F", distance::binary>>) do
      case heading do
        "N" -> {vertical_position + String.to_integer(distance), horizontal_position, heading}
        "S" -> {vertical_position - String.to_integer(distance), horizontal_position, heading}
        "E" -> {vertical_position, horizontal_position + String.to_integer(distance), heading}
        "W" -> {vertical_position, horizontal_position - String.to_integer(distance), heading}
      end
    end

    defp move({vertical_position, horizontal_position, heading}, <<direction::binary-size(1), rotate_degrees::binary>>) do
      {vertical_position, horizontal_position, update_heading(heading, direction, rotate_degrees)}
    end

    ### Part 2 move methods
    ### remember, waypoint positions are relative to the ship
    defp move({ship_vertical, ship_horizontal, waypoint_vertical, waypoint_horizontal}, <<"N", distance::binary>>) do
      {ship_vertical, ship_horizontal, waypoint_vertical + String.to_integer(distance), waypoint_horizontal}
    end

    defp move({ship_vertical, ship_horizontal, waypoint_vertical, waypoint_horizontal}, <<"S", distance::binary>>) do
      {ship_vertical, ship_horizontal, waypoint_vertical - String.to_integer(distance), waypoint_horizontal}
    end

    defp move({ship_vertical, ship_horizontal, waypoint_vertical, waypoint_horizontal}, <<"E", distance::binary>>) do
      {ship_vertical, ship_horizontal, waypoint_vertical, waypoint_horizontal + String.to_integer(distance)}
    end

    defp move({ship_vertical, ship_horizontal, waypoint_vertical, waypoint_horizontal}, <<"W", distance::binary>>) do
      {ship_vertical, ship_horizontal, waypoint_vertical, waypoint_horizontal - String.to_integer(distance)}
    end

    defp move({ship_vertical, ship_horizontal, waypoint_vertical, waypoint_horizontal}, <<"F", distance::binary>>) do
      new_ship_vertical = ship_vertical + String.to_integer(distance) * waypoint_vertical
      new_ship_horizontal = ship_horizontal + String.to_integer(distance) * waypoint_horizontal
      {new_ship_vertical, new_ship_horizontal, waypoint_vertical, waypoint_horizontal}
    end

    defp move({ship_vertical, ship_horizontal, waypoint_vertical, waypoint_horizontal}, <<direction::binary-size(1), rotate_degrees::binary>>) do
      {new_waypoint_vertical, new_waypoint_horizontal} = update_heading(waypoint_vertical, waypoint_horizontal, direction, rotate_degrees)
      {ship_vertical, ship_horizontal, new_waypoint_vertical, new_waypoint_horizontal}
    end

    # part 1
    defp update_heading(original_heading, rotation_direction, rotation_degrees) do
      num_turns = floor(String.to_integer(rotation_degrees) / 90)
      starting_index = Enum.find_index(@compass_directions, &(&1 == original_heading))
      new_index =
        case rotation_direction do
          "R" -> rem(starting_index + num_turns, 4)
          "L" -> starting_index - rem(num_turns, 4)
        end
      Enum.at(@compass_directions, new_index)
    end

    # part 2
    defp update_heading(waypoint_vertical, waypoint_horizontal, rotation_direction, rotation_degrees) do
      vertical_heading = if waypoint_vertical > 0, do: "N", else: "S"
      horizontal_heading = if waypoint_horizontal > 0, do: "E", else: "W"

      new_vertical_heading = update_heading(vertical_heading, rotation_direction,rotation_degrees)
      new_horizontal_heading = update_heading(horizontal_heading, rotation_direction,rotation_degrees)

      new_waypoint_vertical = cond do
        new_vertical_heading == vertical_heading -> waypoint_vertical
        new_horizontal_heading == "N" -> abs(waypoint_horizontal)
        new_horizontal_heading == "S" and waypoint_horizontal < 0 -> waypoint_horizontal
        new_horizontal_heading == "S" -> -(waypoint_horizontal)
        true -> -(waypoint_vertical)
      end

      new_waypoint_horizontal = cond do
        new_horizontal_heading == horizontal_heading -> waypoint_horizontal
        new_vertical_heading == "E" -> abs(waypoint_vertical)
        new_vertical_heading == "W" and waypoint_vertical < 0 -> waypoint_vertical
        new_vertical_heading == "W" -> -(waypoint_vertical)
        true -> -(waypoint_horizontal)
      end

      {new_waypoint_vertical, new_waypoint_horizontal}
    end
  end
