Code.require_file("input_parser.exs", "../helpers")
Code.require_file("timed.exs", "../helpers")
defmodule Day2 do
  defmodule Part1 do
    def prep_for_do(input_list) do
      input_list
      |> Enum.with_index
      |> Map.new(fn {num, idx} -> {idx, num} end)
      |> IO.inspect
      |> Map.put(1, 12)
      |> Map.put(2, 2)
    end
    def after_do(output_map) do
      output_map
      |> IO.inspect
      |> Enum.sort
      |> IO.inspect
      |> Enum.unzip
      |> IO.inspect
      |> elem(1)
      |> hd
    end
    def do_the_thing(input_map) do
      IO.puts "Starting map: #{inspect input_map}"
      recursive_do_thing(input_map)
#      new_map = input_map
#      instruction_chunks = Enum.chunk_every(input_map, 4)
#      try do
#        for chunk <- instruction_chunks do
#          x = case chunk do
#            [{_, 1} | ops] -> add_operation(ops, input_map)
#            [{_, 2} | ops] -> multiply_operation(ops, input_map)
#            [{_, 99} | _] -> throw(:break)
#            e -> raise "Unknown Operator: #{e}"
#          end
#          Map.merge(new_map, x) |> IO.inspect
#        end
#        new_map |> IO.inspect
#      catch
#        :break ->
#          IO.puts("BREAKING LOOP")
#          input_map
#      end
    end
    
    def run_brute() do
      InputParser.get_input_list_for_day(2, ",", true)
      |> prep_for_do
      |> do_the_thing
      |> after_do
    end
    
    def recursive_do_thing(input_map, starting_index \\ 0) do
      chunk = [Map.get(input_map, starting_index), Map.get(input_map, starting_index + 1), Map.get(input_map, starting_index + 2), Map.get(input_map, starting_index + 3)]
      IO.puts("INPUT: #{inspect input_map}, starting: #{starting_index}, chunk: #{inspect chunk}")
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
          IO.puts("BREAKING LOOP")
          input_map
      end
    end
    
    def add_operation([pos1, pos2, respos], input_map) do
      IO.puts("Adding: #{pos1} and #{pos2}")
      res = Map.get(input_map, pos1) + Map.get(input_map, pos2)
      IO.puts("SUM = #{res}, placing at #{respos}")
      Map.put(input_map, respos, res)
    end
    
    def multiply_operation([pos1, pos2, respos], input_map) do
      IO.puts("Multiplying #{pos1} and #{pos2}")
      res = Map.get(input_map, pos1) * Map.get(input_map, pos2)
      IO.puts("PRODUCT = #{res}, placing at #{respos}")
      Map.put(input_map, respos, res)
    end
  end
end