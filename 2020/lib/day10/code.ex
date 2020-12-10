  defmodule Advent2020.Day10 do
    import Helpers.Shared, only: [log: 1]
    @edges_to_combinations_map %{1 => 1, 2 => 1, 3 => 2, 4 => 4, 5 => 7} # figured out by hand/with graph lib; only used as many as the example inputs needed

    def part1(input) do
      log("Running 2020-10-P1-InputList")
      {_, %{1 => ones, 3 => threes}} =
        input
        |> Enum.map(&String.to_integer/1)
        |> Enum.sort()
        |> Enum.reduce({0, %{1 => 0, 2 => 0, 3 => 1}}, fn val, {prev, acc_map} ->
          joltage_diff = val - prev
          {val, Map.update!(acc_map, joltage_diff, &(&1 + 1))}
        end)
        |> IO.inspect

      ones * threes
    end

    def part1_optimized(input) do
      log("Running 2020-10-P1-InputListOptimized")
      "Not implemented"
    end

    def part1_stream(input_stream) do
      log("Running 2020-10-P1-InputStream")
      "Not implemented"
    end

    def part2(input) do
      log("Running 2020-10-P2-InputList")
      all_adapters = [0 | Enum.map(input, &String.to_integer/1)]
#      {min, max} = Enum.min_max(all_adapters)
      all_adapters = all_adapters ++ [Enum.max(all_adapters) + 3]

      graph =
        Graph.new()
        |> build_vertices(all_adapters)
        |> build_edges(all_adapters)

      {:ok, dotfile} = Graph.to_dot(graph)
      File.write("lib/day10/dotfile_p2_ex_2", dotfile)

#      paths_from_start_to_end = Graph.get_paths(graph, min, max) <== this takes way too long :(
#      Enum.count(paths_from_start_to_end)

#      get_paths_to_end(graph)  |> IO.inspect
      {all_chunks, last_chunk, _} = chunk_contiguous_parts(Enum.sort(all_adapters))
      all_chunks = [last_chunk | all_chunks]
      calculate_possibilities(all_chunks)
    end

    def part2_optimized(input) do
      log("Running 2020-10-P2-InputListOptimized")
      "Not implemented"
    end

    def part2_stream(input_stream) do
      log("Running 2020-10-P2-InputStream")
      "Not implemented"
    end

    defp build_vertices(starting_graph, all_adapters) do
      Graph.add_vertices(starting_graph, all_adapters)
    end

    defp build_edges(starting_graph, all_adapters) do
      Enum.reduce(all_adapters, starting_graph, fn adapter, graph ->
        connectable_adapters = Enum.filter(all_adapters, fn other_adapter -> other_adapter - adapter in 1..3 end)
        log("Adapter #{adapter} can connect to: #{inspect(connectable_adapters, charlists: :as_lists)}")
        add_adapters_to_graph(graph, connectable_adapters, adapter)
      end)
    end

    defp add_adapters_to_graph(starting_graph, connectable_adapters, starting_adapter) do
      Enum.reduce(connectable_adapters, starting_graph, fn connectable_adapter, graph ->
        Graph.add_edge(graph, starting_adapter, connectable_adapter)
      end)
    end

#    defp get_paths_to_end(graph, adapters_list) do
#      Enum.reduce(adapters_list, 1, fn adapter, possibilities ->
#        edges = Graph.out_degree(graph, adapter)
#        combinations = Map.get(@edges_to_combinations_map, edges, 1)
#        IO.puts("#{adapter} has #{edges} out edges which is equivalent to #{combinations}")
#        possibilities + combinations
#      end)
#    end

    defp get_paths_to_end(graph, adapter \\ 0, possibilities \\ 1) do
      case Graph.out_degree(graph, adapter) do
        0 ->
          log("last adapter #{adapter}")
          possibilities
        1 ->
          log("possibilities for adapter #{adapter}: #{possibilities}")
          next_adapter = Enum.max(Graph.out_neighbors(graph, adapter))
          get_paths_to_end(graph, next_adapter, possibilities)
        n ->
          next_adapter = Enum.max(Graph.out_neighbors(graph, adapter))
          new_possibilities = possibilities * Map.get(@edges_to_combinations_map, n)
          log("possibilities for adapter #{adapter} [#{n}-degree]: #{possibilities} * #{Map.get(@edges_to_combinations_map, n)}")
          get_paths_to_end(graph, next_adapter, new_possibilities)
      end
    end

    defp chunk_contiguous_parts(sorted_adapters) do
      Enum.reduce(sorted_adapters, {[], [], nil}, fn adapter, {all_chunks, current_chunk, last_adapter} ->
        # if adapter - last adapter >= 3, that means the last adaptre is the only link to this one, feel free to close the chuunk
        # then: acc (lisst of lists) append (curr chunk). start next gen with empty chunk
        # else, this adapter is still part of the previous chunk
        # then: append to curr chunk
        # SPECIAL CASE, nil, just add to the chunk because it's the first/fixed adapter
        log("curr iter: #{inspect({adapter, all_chunks, current_chunk, last_adapter}, charlists: :as_lists)}")
        cond do
          last_adapter == nil ->
            log("first adapter, adding to chunk and continuing")
            {all_chunks, [adapter], adapter}
          adapter - last_adapter < 3 ->
            log("adding to previous chunk")
            {all_chunks, current_chunk ++ [adapter], adapter}
          true ->
            log("starting new chunk")
            {[current_chunk | all_chunks], [adapter], adapter}
        end
      end)
    end

    defp calculate_possibilities(chunked_adapters) do
      Enum.reduce(chunked_adapters, 1, fn chunk, product ->
        combinations = Map.get(@edges_to_combinations_map, Enum.count(chunk))
        product * combinations
      end)
    end
  end
