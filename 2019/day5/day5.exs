Code.require_file("input_parser.exs", "../helpers")
Code.require_file("timed.exs", "../helpers")
defmodule Day5 do
  defmodule Part1 do
    def run_brute() do
      InputParser.get_input_list_for_day(5, ",", true)
      |> prep_for_do
      |> do_the_thing(0, 1)
      |> after_do
    end
    defp prep_for_do(input_list) do
      input_list
      |> Enum.with_index
      |> Map.new(fn {num, idx} -> {idx, num} end)
    end
    defp after_do(output_list) do
      IO.inspect(output_list)
    end
    def do_the_thing(input_map, instruction_index, input_val, output_list \\ []) do
      instruction = Map.get(input_map, instruction_index)
      if instruction_index < Enum.count(input_map) do
        try do
          IO.puts("INTERPRETING: #{instruction} at #{instruction_index}")
          {new_map, new_start_index, new_output_list} =
            interpret_instruction(Integer.digits(instruction), input_map, instruction_index, input_val, output_list)
          do_the_thing(new_map, new_start_index, input_val, new_output_list)
        catch
          :break ->
            IO.puts("BREAKING LOOP: #{inspect input_map, limit: :infinity}")
            output_list
        end
      else
        IO.puts("FINAL MAP: #{inspect input_map, limit: :infinity}")
        output_list
      end
    end

    def interpret_instruction(digits, input_map, instruction_index, input_val, output_list) do
      case digits do
        [3] -> 
          { perform_input(input_map, Map.get(input_map, instruction_index + 1), input_val), instruction_index + 2, output_list }
        [1, 0, 3] -> 
          { perform_input(input_map,  instruction_index + 1, input_val), instruction_index + 2, output_list }
        [4] ->
          new_output_list = perform_output(input_map, Map.get(input_map, instruction_index + 1), output_list)
          {input_map, instruction_index + 2, new_output_list}
        [1, 0, 4] ->
          new_output_list = perform_output(input_map, instruction_index + 1, output_list)
          {input_map, instruction_index + 2, new_output_list}
        [9, 9] -> throw(:break)
        [mode3, mode2, mode1, opcode1, opcode2] -> 
          { perform_operation(input_map, instruction_index + 1, Integer.undigits([opcode1, opcode2]), [mode1, mode2, mode3]),
            instruction_index + 4,
            output_list }
        [mode2, mode1, opcode1, opcode2] -> 
          { perform_operation(input_map, instruction_index + 1, Integer.undigits([opcode1, opcode2]), [mode1, mode2, 0]),
            instruction_index + 4,
            output_list }
        [mode1, opcode1, opcode2] -> 
          { perform_operation(input_map, instruction_index + 1, Integer.undigits([opcode1, opcode2]), [mode1, 0, 0]),
            instruction_index + 4,
            output_list }
        [opcode1, opcode2] -> 
          { perform_operation(input_map, instruction_index + 1, Integer.undigits([opcode1, opcode2]), [0, 0, 0]),
            instruction_index + 4,
            output_list }
        [opcode1] ->
          { perform_operation(input_map, instruction_index + 1, opcode1, [0, 0, 0]),
            instruction_index + 4,
            output_list }
        e -> raise "Unknown Operator: #{inspect e}"
      end
    end
    
    def perform_input(input_map, position_index, input_val) do
      IO.puts("SAVING INPUT #{input_val} TO POS: #{position_index}")
      Map.put(input_map, position_index, input_val)
    end
    
    def perform_output(input_map, position_index, output_list) do
      IO.puts("OUTPUTTING #{Map.get(input_map, position_index)}")
      [Map.get(input_map, position_index) | output_list]
    end
    
    def perform_operation(input_map, position_index, opcode, modes) do
      chunk = [Map.get(input_map, position_index), Map.get(input_map, position_index + 1), Map.get(input_map, position_index + 2)]
      IO.inspect("PERFORMING: #{opcode} WITH MODES: #{inspect modes} ON ARGS: #{inspect chunk}")
      case opcode do
        1 -> add_operation(input_map, chunk, modes)
        2 -> multiply_operation(input_map, chunk, modes)
      end
    end
    
    def add_operation(input_map, [arg1, arg2, sum_position], [mode1, mode2, mode3]) do
      addend1 = get_argument(input_map, arg1, mode1)
      addend2 = get_argument(input_map, arg2, mode2)
      IO.puts("ADDING #{addend1} + #{addend2} AT #{sum_position}")
      case mode3 do
        0 -> Map.put(input_map, sum_position, addend1 + addend2)
        1 -> raise "Cannot write add result in immediate mode #{inspect [arg1, arg2, sum_position, mode1, mode2, mode3]}"
      end
    end
    
    def multiply_operation(input_map, [arg1, arg2, product_position], [mode1, mode2, mode3]) do
      factor1 = get_argument(input_map, arg1, mode1)
      factor2 = get_argument(input_map, arg2, mode2)
      IO.puts("MULTIPLYING #{factor1} × #{factor2} AT #{product_position}")
      case mode3 do
        0 -> Map.put(input_map, product_position, factor1 * factor2)
        1 -> raise "Cannot write multiplication result in immediate mode #{inspect [arg1, arg2, product_position, mode1, mode2, mode3]}"
      end
    end
    
    defp get_argument(input_map, arg, mode) do
      case mode do
        0 -> Map.get(input_map, arg)
        1 -> arg
      end
    end
  end
   
  defmodule Part2 do
    def run_brute() do
    end
    def do_the_thing do
    end
  end
end

