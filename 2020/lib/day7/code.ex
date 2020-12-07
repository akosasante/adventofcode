defmodule Advent2020.Day7 do
  import Helpers.Shared, only: [log: 1]
  @bag_of_interest "shiny gold"

  def part1(input) do
    log("Running 2020-7-P1-InputList")

    all_bags =
      Enum.map(input, fn line ->
        {holder_bag, contained_bags} = parse_line(line)
      end)

    graph =
      Graph.new()
      |> build_vertices(all_bags)
      |> build_edges(all_bags)

    {:ok, dotfile} = Graph.to_dot(graph)
    File.write("lib/day7/dotfile_p1", dotfile)

    get_number_of_bags_that_contain(@bag_of_interest, graph)
  end

  def part1_optimized(input) do
    log("Running 2020-7-P1-InputListOptimized")
    "Not implemented"
  end

  def part1_stream(input_stream) do
    log("Running 2020-7-P1-InputStream")
    "Not implemented"
  end

  def part2(input) do
    log("Running 2020-7-P2-InputList")

    all_bags =
      Enum.map(input, fn line ->
        {holder_bag, contained_bags} = parse_line(line)
      end)

    graph =
      Graph.new()
      |> build_vertices(all_bags)
      |> build_edges(all_bags)

    reachable_n = Graph.reachable(graph, [@bag_of_interest])
    subgraph = Graph.subgraph(graph, reachable_n)

    #    innermost_bags = get_innermost_bags(subgraph)

    #    get_paths =
    #      get_all_paths(graph, innermost_bags, @bag_of_interest)
    #      |> IO.inspect()

    {:ok, dotfile} = Graph.to_dot(subgraph)
    File.write("lib/day7/dotfile_p2", dotfile)

    traverse_graph_and_sum_bags(subgraph, [{@bag_of_interest, 1}], 0)
  end

  def part2_optimized(input) do
    log("Running 2020-7-P2-InputListOptimized")
    "Not implemented"
  end

  def part2_stream(input_stream) do
    log("Running 2020-7-P2-InputStream")
    "Not implemented"
  end

  defp parse_line(line) do
    pattern = ~r/^(.+) bags contain (.+).$/
    [holder_bag, contained_bags] = Regex.run(pattern, line, capture: :all_but_first)
    #      holder_bag_name = convert_bag_name(holder_bag)
    contained_bags_list = String.split(contained_bags, ", ", trim: true)
    {holder_bag, contained_bags_list}
  end

  #    defp convert_bag_name(bag_name_string) do
  #      bag_name_string
  #      |> String.split(" ", trim: true)
  #      |> Enum.join("_")
  #    end

  defp build_vertices(starting_graph, all_bags_list) do
    Enum.reduce(all_bags_list, starting_graph, fn {holding_bag, _}, graph ->
      Graph.add_vertex(graph, holding_bag)
    end)
  end

  defp build_edges(starting_graph, all_bags_list) do
    Enum.reduce(all_bags_list, starting_graph, fn {holding_bag, contained_bags_list}, graph ->
      add_edges_for_list_of_bags(contained_bags_list, graph, holding_bag)
    end)
  end

  defp parse_edge_bag_text("no other bags"), do: [nil, nil]

  defp parse_edge_bag_text(text) do
    pattern = ~r/^(\d+) (.+) bag[s]*$/
    Regex.run(pattern, text, capture: :all_but_first)
  end

  defp add_edges_for_list_of_bags(contained_bags_list, starting_graph, holding_bag) do
    Enum.reduce(contained_bags_list, starting_graph, fn contained_bag, graph ->
      [num_bags, bag_name] = parse_edge_bag_text(contained_bag)

      case num_bags do
        nil -> graph
        #          _ -> Graph.add_edge(graph, holding_bag, bag_name, weight: String.to_integer(num_bags))
        _ -> Graph.add_edge(graph, holding_bag, bag_name, label: String.to_integer(num_bags))
      end
    end)
  end

  defp get_number_of_bags_that_contain(bag_name, graph),
    do: Enum.count(Graph.reaching_neighbors(graph, [bag_name]))

  #  defp traverse_and_sum(graph) do
  #          Graph.Reducers.Bfs.reduce(graph, {nil, 0}, fn vertex, {parent_vertex, current_sum} ->
  #            case parent_vertex do
  #              nil ->
  #                IO.puts "Only should happen for the first one #{vertex}"
  #                {:next, {vertex}}
  #              _ ->
  #                IO.puts "\nCurrent parent: #{parent_vertex} | Current vertex: #{vertex}"
  #                IO.inspect(Graph.edges(graph, parent_vertex, vertex))
  #                {:next, {vertex}}
  #            end
  #
  #    #        if (vertex == "shiny gold") do
  #    #          IO.puts "skipping #{vertex}"
  #    #          {:skip, sum}
  #    #        else
  ##              IO.puts(vertex)
  ##              IO.inspect(Graph.edges(graph, "shiny gold", vertex))
  ##              IO.inspect(Graph.get_paths(graph, "shiny gold", vertex))
  ##              {:next, sum}
  #    #        end
  #          end)
  #  end

  #    defp get_innermost_bags(graph) do
  #      Graph.Reducers.Dfs.reduce(graph, [], fn vertex, acc ->
  #        if Graph.out_degree(graph, vertex) > 0 do
  #          {:skip, acc}
  #        else
  #          {:next, [vertex | acc]}
  #        end
  #      end)
  #    end
  #
  #    defp get_all_paths(graph, bags, bag_of_interest) do
  #      Enum.map(bags, fn bag -> Graph.get_paths(graph, bag_of_interest, bag) end)
  #    end

  defp traverse_graph_and_sum_bags(_graph, [], sum), do: sum

  defp traverse_graph_and_sum_bags(graph, [{vertex, multiplier} | rest] = vertices_to_visit, sum) do
    IO.puts("Visiting #{vertex} with multiplier #{multiplier}")

    case Graph.out_edges(graph, vertex) do
      [] ->
        IO.puts("this vertex has no edges, returning sum #{sum}")
        traverse_graph_and_sum_bags(graph, rest, sum)

      edges ->
        IO.puts("handling edges")

        {acc_sum, [_ | acc_vertices]} =
          Enum.reduce(edges, {sum, vertices_to_visit}, fn %Graph.Edge{v2: v2, label: num_bags},
                                                          {curr_sum, curr_vertices} ->
            IO.puts(
              "Each #{vertex} bag (of which we have #{multiplier}) contains #{num_bags} #{v2} bags. Prev sum: #{
                curr_sum
              }. New sum #{curr_sum + num_bags * multiplier}"
            )

            {curr_sum + num_bags * multiplier, curr_vertices ++ [{v2, num_bags * multiplier}]}
          end)

        traverse_graph_and_sum_bags(graph, acc_vertices, acc_sum)
    end
  end
end
