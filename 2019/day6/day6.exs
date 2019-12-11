Code.require_file("input_parser.exs", "../helpers")
Code.require_file("timed.exs", "../helpers")
defmodule Day6 do
  defmodule Part1 do
    def run_brute() do
      InputParser.get_input_list_for_day(6)
      |> prep_input
      |> do_the_thing
      |> after_run
    end
    def do_the_thing(adjacency_map) do
      dfs(adjacency_map)
    end
    def after_run(arg) do
      Enum.sum(arg)
    end
    
    def dfs(adjacency_map, orbits_count \\ 0) do
      Enum.map(adjacency_map, fn {node, children} ->
#        IO.puts("N=#{node} C=#{inspect children}")
        visit_children(adjacency_map, children)
      end)      
    end
    
    def visit_children(map, [next_child | _], count \\ 1) do 
      case Map.get(map, next_child) do
        nil -> count
        something -> 
#          IO.puts("Found child of #{next_child}: #{something}, count=#{count}")
          visit_children(map, something, count + 1)
      end
    end
    
    def prep_input(input_list) do
      input_list
      |> Enum.map(&(String.split(&1, ")")))
      |> Enum.reduce(%{}, fn [child, node], node_map ->
        new_children = case Map.get(node_map, node) do
          [_ | _] = children -> [child | children]
          _ -> [child]
        end
        Map.put(node_map, node, new_children)
      end)
    end
  end
   
  defmodule Part2 do
    def run_brute() do
      InputParser.get_input_list_for_day(6)
      |> prep_input
      |> do_the_thing("YOU", "SAN")
      |> after_run
    end
    
    def prep_input(input_list) do
      index_list = Enum.map(input_list, fn pair ->
        String.split(pair, ")")
      end)
      |> Enum.flat_map(&(&1))
      |> Enum.uniq
      
      symbol_map = index_list
      |> Enum.with_index
      |> Map.new(fn {idx, num} -> {idx, num} end)

      size = Enum.count(index_list)
      empty_list = List.duplicate(:empty, size)
      visited_list = List.duplicate(false, size)
      
      adjacency_list = Enum.reduce(input_list, empty_list, fn pair, acc ->
        [planet1, planet2] = String.split(pair, ")")
        acc = update_adjacency_list(acc, symbol_map, planet1, planet2)
        update_adjacency_list(acc, symbol_map, planet2, planet1)
      end)
      
      {visited_list, symbol_map, adjacency_list}
    end
    
    def update_adjacency_list(adj_list, symbol_map, left_node, right_node) do
      List.update_at(adj_list, Map.get(symbol_map, left_node), fn curr_val ->
        case curr_val do
          :empty -> [right_node]
          [_ | _] = list -> [right_node | list]
          _ -> raise "ERROR UPDATING ADJ LIST"
        end
      end)
    end

    def do_the_thing({visited_list, symbol_map, adjacency_list}, start_node, destination_node) do
      queue = :queue.new()
      try do
        queue = :queue.in(start_node, queue)
        visited_list = List.update_at(visited_list, Map.get(symbol_map, start_node), fn _ -> -1 end)
        bfs(adjacency_list, symbol_map, visited_list, queue, destination_node)
      catch
        {:break, count} -> count
      end
    end
    
    def bfs(adjacency_list, symbol_map, visited_list, q, stop) do
#      children = Map.get(adjacency_map, start)
#      IO.inspect(children)
      IO.inspect(q)
      IO.inspect(visited_list)
#      IO.inspect(symbol_map)
      
      {q, last_node} = case :queue.out(q) do
        {:empty, _} -> throw(:end)
        {{:value, last_node}, queue} -> {queue, last_node}
      end
      
      children = Enum.at(adjacency_list, Map.get(symbol_map, last_node))
      {q, visited_list} = Enum.reduce(children, {q, visited_list}, fn child, {acc_q, acc_vl} ->
        val = Enum.at(acc_vl, Map.get(symbol_map, child))
        if child == stop do
#          IO.puts("FINISHED: #{Enum.at(visited_list, Map.get(symbol_map, "I"))}")
          throw({:break, Enum.at(visited_list, Map.get(symbol_map, last_node))})
        end
        if (val == false) do
          new_val =  (Enum.at(acc_vl, Map.get(symbol_map, last_node)) || 0) + 1
          IO.puts("QUEUING NEW NODE #{child}, #{val}, #{last_node}:#{new_val}....#{inspect acc_vl}")
          { :queue.in(child, acc_q), List.update_at(acc_vl, Map.get(symbol_map, child), fn _ -> new_val end) }
        else
          IO.puts("ALREADY VISITED #{child}, #{inspect acc_vl}")
          { acc_q, acc_vl }
        end
      end)
      
      bfs(adjacency_list, symbol_map, visited_list, q, stop)
    end
    
    def after_run(arg) do
      IO.inspect(arg)
    end
  end
end

