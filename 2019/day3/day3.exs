Code.require_file("input_parser.exs", "../helpers")
Code.require_file("timed.exs", "../helpers")
defmodule Day3 do
  defmodule Part1 do
    def run_brute() do
      InputParser.get_input_stream_for_day(3)
      |> Enum.map(&(String.split(&1, ",")))
      |> do_the_thing
    end
    def do_the_thing([wire1, wire2]) do
      wire1steps = []
      wire2steps = []
      start_position = {0, 0}
      IO.puts("MOVE WIRE 1")
      {wire1_end_position, wire1steps} = run_instruction_set(wire1, start_position, wire1steps)
      IO.puts("MOVE WIRE 2")
      {wire2_end_position, wire2steps} = run_instruction_set(wire2, start_position, wire2steps)
      
      IO.puts("Wire1 end: #{inspect wire1_end_position}; Wire2 end: #{inspect wire2_end_position}")
      
      intersections = MapSet.intersection(MapSet.new(wire1steps), MapSet.new(wire2steps))
      IO.puts("Intersections: #{inspect intersections}")
      
      {min_x, min_y} = Enum.min_by(intersections, fn {x_val, y_val} = intersection -> 
        sum = abs(x_val) + abs(y_val)
        IO.puts("Intersection: #{inspect intersection}; Distance=#{sum}")
        sum
      end)
      abs(min_x) + abs(min_y)
    end
    
    defp run_instruction_set(instructions, start_position, wire_steps) do
      Enum.reduce(instructions, {start_position, wire_steps}, fn instruction, {new_curr_pos, new_steps} ->
        IO.puts("instruction: #{instruction}, starting from : #{inspect new_curr_pos}")
        case instruction do
          "R" <> num_steps -> compute_movement(new_curr_pos, new_steps, String.to_integer(num_steps), 0)
          "L" <> num_steps -> compute_movement(new_curr_pos, new_steps, -(String.to_integer(num_steps)), 0)
          "U" <> num_steps -> compute_movement(new_curr_pos, new_steps, 0, String.to_integer(num_steps))
          "D" <> num_steps -> compute_movement(new_curr_pos, new_steps, 0, -(String.to_integer(num_steps)))
        end
      end)
    end
    
    defp compute_movement(curr_position, wire_steps, x_axis_steps, y_axis_steps) do
      new_position = update_curr_position(curr_position, x_axis_steps, y_axis_steps)
      movement = case x_axis_steps do
        0 -> 
          skip_val = elem(curr_position, 1)
          Enum.map(elem(curr_position, 1)..(elem(curr_position, 1) + y_axis_steps),  fn 
            val when val !=skip_val -> {elem(curr_position, 0), val}
            _ -> nil
          end) |> Enum.reject(&is_nil/1)
        _ -> 
          skip_val = elem(curr_position, 0)
          Enum.map(elem(curr_position, 0)..(elem(curr_position, 0) + x_axis_steps),  fn 
            val when val !=skip_val -> {val, elem(curr_position, 1)} 
            _ -> nil
          end) |> Enum.reject(&is_nil/1)
      end
      wire_steps = Enum.concat(wire_steps, movement)
      {new_position, wire_steps}
    end
    
    defp update_curr_position(curr_position, x_axis_steps, y_axis_steps) do
      {elem(curr_position, 0) + x_axis_steps, elem(curr_position, 1) + y_axis_steps}
    end
  end
  defmodule Part2 do
    def run_brute() do
    end
    def do_the_thing do
    end
  end
end

