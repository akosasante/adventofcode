Code.require_file("input_parser.exs", "../helpers")
Code.require_file("timed.exs", "../helpers")
defmodule Day2 do
  defmodule Part1 do
    def do_the_thing(input_map) do
#      IO.puts "Starting map: #{inspect input_map}"
      recursive_do_thing(input_map)
    end
    
    def run_brute() do
      InputParser.get_input_list_for_day(2, ",", true)
      |> prep_for_do
      |> do_the_thing
      |> after_do
    end
    
    defp prep_for_do(input_list) do
      input_list
      |> Enum.with_index
      |> Map.new(fn {num, idx} -> {idx, num} end)
      |> Map.put(1, 12)
      |> Map.put(2, 2)
    end
    defp after_do(output_map) do
      output_map
      |> Enum.sort
      |> Enum.unzip
      |> elem(1)
      |> hd
    end
    
    defp recursive_do_thing(input_map, starting_index \\ 0) do
      chunk = [Map.get(input_map, starting_index), Map.get(input_map, starting_index + 1), Map.get(input_map, starting_index + 2), Map.get(input_map, starting_index + 3)]
#      IO.puts("INPUT: #{inspect input_map}, starting: #{starting_index}, chunk: #{inspect chunk}")
      try do
        new_map = case chunk do
          [1 | ops] -> add_operation(ops, input_map)
          [2 | ops] -> multiply_operation(ops, input_map)
          [99 | _] -> throw(:break)
          e -> raise "Unknown Operator: #{e}"
        end
        recursive_do_thing(new_map, starting_index + 4)
      catch
        :break ->
#          IO.puts("BREAKING LOOP")
          input_map
      end
    end
    
    defp add_operation([pos1, pos2, respos], input_map) do
#      IO.puts("Adding: #{pos1} and #{pos2}")
      res = Map.get(input_map, pos1) + Map.get(input_map, pos2)
#      IO.puts("SUM = #{res}, placing at #{respos}")
      Map.put(input_map, respos, res)
    end
    
    defp multiply_operation([pos1, pos2, respos], input_map) do
#      IO.puts("Multiplying #{pos1} and #{pos2}")
      res = Map.get(input_map, pos1) * Map.get(input_map, pos2)
#      IO.puts("PRODUCT = #{res}, placing at #{respos}")
      Map.put(input_map, respos, res)
    end
  end
  
  defmodule Part2 do
    defp do_the_thing(input_map) do
      Day2.Part1.do_the_thing(input_map)
    end
    
    def run_brute() do
      input = InputParser.get_input_list_for_day(2, ",", true)
      try do
        for noun <- 0..99 do
          for verb <- 0..99 do
            IO.puts("TRYING: noun=#{noun} verb=#{verb}")
            res = input
            |> prep_for_do(noun, verb)
            |> do_the_thing
            |> after_do
            if res == 19690720 do
              throw({:complete, noun, verb})
            end
          end
      end
      catch
        {:complete, noun, verb} ->
          IO.puts("FOUND NUMBERS: noun=#{noun} verb=#{verb}")
          100 * noun + verb
      end
    end
    
    defp prep_for_do(input_list, num1, num2) do
      input_list
      |> Enum.with_index
      |> Map.new(fn {num, idx} -> {idx, num} end)
      |> Map.put(1, num1)
      |> Map.put(2, num2)
    end

    defp after_do(output_map) do
      output_map
      |> Enum.sort
      |> Enum.unzip
      |> elem(1)
      |> hd
      |> IO.inspect
    end

  end
end
