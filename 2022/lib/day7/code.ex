defmodule Advent2022.Day7 do
  require Logger

  defmodule State do
    defstruct filesystem: Graph.new(type: :directed), last_command: nil, current_directory: nil
  end

  defmodule SystemNode do
    @valid_types [:file, :dir]
    defstruct id: nil, type: :file, size: 0, name: ""

    def new(opts) do
      name = Keyword.fetch!(opts, :name)
      type = Keyword.fetch!(opts, :type)
      size = Keyword.get(opts, :size, 0)
      unless(type in @valid_types) do
        raise RuntimeError, "SystemNode struct can only have type in: #{inspect(@valid_types)}"
      end
      unless(is_number(size)) do
        raise RuntimeError, "SystemNode size must be a number"
      end
      %__MODULE__{id: make_ref(), name: name, type: type, size: size}
    end

    def vertex_labels(%__MODULE__{type: :dir, size: size, name: name}) when size > 0 do
      [:dir, name, size]
    end
    def vertex_labels(%__MODULE__{type: :dir, name: name}), do: [:dir, name]
    def vertex_labels(%__MODULE__{type: :file, name: name, size: size}), do: [:file, name, size]

    def is_directory?(%__MODULE__{type: :dir}), do: true
    def is_directory?(_), do: false

    def is_file?(%__MODULE__{type: :file}), do: true
    def is_file?(_), do: false
  end

  defimpl Inspect, for: SystemNode do
    def inspect(%SystemNode{} = node, _opts) do
      node.name
    end
  end

  defimpl String.Chars, for: SystemNode do
    def to_string(node) do
      node.name
    end
  end

  def part1(input) do
    Logger.info("Running 2022-7-P1-InputList")
    input
    |> construct_filesystem()
    |> calculate_directory_sizes(:libgraph)
    |> IO.inspect(label: :input_for_day1, pretty: true)
    |> sum_of_largest_directories(max: 100000)
  end

  defp construct_filesystem(input) do
    input
    |> Enum.reduce(
         %State{},
         fn line, %State{last_command: last_cmd} = curr_state ->
           IO.puts(IO.ANSI.format([:light_blue_background, "LAST CMD=#{last_cmd} | CURR_CMD=#{line}"]))
           case [last_cmd, parse_command(line)] do
             [:ls, :not_a_command] ->
               list_children_and_update_state(curr_state, line)
               |> IO.inspect(label: :res_of_ls)
             [_, {:ls, nil}] ->
               %State{curr_state | last_command: :ls}
               |> IO.inspect(label: :res_of_starting_ls)
             [_, {cmd, destination}] when cmd == :cd or is_nil(cmd) ->
               change_directory_and_update_state(curr_state, destination)
               |> IO.inspect(label: :res_of_cmd)
           end
         end
       )
    #    |> tap(fn %State{filesystem: graph} -> print_graph(graph) end)
  end

  defp parse_command("$ cd " <> argument) do
    destination_directory = case argument do
      ".." -> :parent
      "/" -> :root
      dir_name -> dir_name
    end
    {:cd, destination_directory}
  end
  defp parse_command("$ ls"), do: {:ls, nil}
  defp parse_command(_), do: :not_a_command

  defp change_directory_and_update_state(%State{filesystem: graph} = curr_state, :root) do
    node = SystemNode.new(name: "root", type: :dir)

    %State{
      curr_state |
      current_directory: node,
      filesystem: Graph.add_vertex(graph, node, SystemNode.vertex_labels(node)),
      last_command: :cd
    }
  end
  defp change_directory_and_update_state(
         %State{current_directory: curr_dir, filesystem: graph} = curr_state,
         :parent
       ) do
    case Graph.in_neighbors(graph, curr_dir) do
      [parent_dir] -> %State{curr_state | current_directory: parent_dir, last_command: :cd}
      unexpected_parent ->
        print_graph(graph)
        raise RuntimeError, "Expected exactly one parent to #{curr_dir}. Found: #{inspect(unexpected_parent)}."
    end
  end
  defp change_directory_and_update_state(
         %State{current_directory: curr_dir, filesystem: graph} = curr_state,
         destination_dir
       ) do
    children = Graph.out_neighbors(graph, curr_dir)
    case Enum.find(children, & &1.name == destination_dir) do
      nil ->
        print_graph(graph)
        raise RuntimeError, "Expected to find #{destination_dir} as a child of #{curr_dir} but did not."
      vertex ->
        unless SystemNode.is_directory?(vertex) do
          print_graph(graph)
          raise RuntimeError, "Expected destination to be a directory, got: #{inspect(vertex)}"
        end
        %State{curr_state | current_directory: vertex, last_command: :cd}
    end
  end

  defp list_children_and_update_state(
         %State{current_directory: curr_dir, filesystem: graph} = curr_state,
         "dir " <> directory_name
       ) do

    node = SystemNode.new(name: directory_name, type: :dir)
    updated_graph = graph
                    |> Graph.add_vertex(node, SystemNode.vertex_labels(node))
                    |> Graph.add_edge(curr_dir, node)

    %State{curr_state | filesystem: updated_graph}
  end
  defp list_children_and_update_state(%State{current_directory: curr_dir, filesystem: graph} = curr_state, file) do
    [size, filename] = String.split(file, " ")
    size = String.to_integer(size)

    node = SystemNode.new(name: filename, type: :file, size: size)
    updated_graph = graph
                    |> Graph.add_vertex(node, SystemNode.vertex_labels(node))
                    |> Graph.add_edge(curr_dir, node)

    %State{curr_state | filesystem: updated_graph}
  end

  defp calculate_directory_sizes(%State{filesystem: graph}, :libgraph) do
    graph
    |> get_directories()
    |> Enum.reduce(graph, fn directory, updated_graph ->
      dir_size = Graph.reachable_neighbors(graph, [directory])
                 |> Enum.filter(&SystemNode.is_file?/1)
                 |> Enum.map(& &1.size)
                 |> Enum.sum()

      Graph.replace_vertex(updated_graph, directory, SystemNode.new(name: directory.name, type: :dir, size: dir_size))
    end)
  end

  #  defp calculate_directory_sizes(%State{filesystem: graph}, :libgraph_reduce) do
  #    Graph.Reducers.Dfs.reduce(graph, %{}, fn vertex, size_map ->
  #      if is_file(vertex, graph) do
  #        {:skip, size_map}
  #      else
  #        M
  #      end
  #    end)
  #  end

  #  defp is_file(vertex, graph) do
  #    match?([:file, ^vertex, _file_size], Graph.vertex_labels(graph, vertex))
  #  end

  # defp calculate_directory_sizes(%State{filesystem: graph}, :dfs) do

  defp sum_of_largest_directories(graph_with_sizes, opts) do
    max_size = Keyword.get(opts, :max, 100000)

    Enum.reduce(
      get_directories(graph_with_sizes),
      0,
      fn directory, sum ->
        if directory.size <= max_size do
          sum + directory.size
        else
          sum
        end
      end
    )
  end

  defp get_directories(%Graph{} = graph) do
    Graph.vertices(graph) |> Enum.filter(&SystemNode.is_directory?/1)
  end

  defp get_files(%Graph{} = graph) do
    Graph.vertices(graph) |> Enum.filter(&SystemNode.is_file?/1)
  end

  defp get_vertex_by_node_name(%Graph{} = graph, name) do
    Graph.vertices(graph) |> Enum.find(fn %SystemNode{name: node_name} -> node_name == name end)
  end

  defp print_graph(graph) do
    {:ok, graph_dot} = Graph.to_dot(graph)
    filename = "./temp_#{
      :rand.uniform * 100
      |> round
    }"
    File.write!(filename <> ".dot", graph_dot)
    {_, 0} = System.cmd(
      "dot",
      [
        "-T",
        "pdf",
        filename <> ".dot",
        "-o",
        filename <> ".pdf"
      ]
    )
    {_, 0} = System.cmd("open", [filename <> ".pdf"])
  end


  def part2(input) do
    Logger.info("Running 2022-7-P2-InputList")
    directory_to_delete = input
                                  |> construct_filesystem()
                                  |> calculate_directory_sizes(:libgraph)
                                  |> IO.inspect(label: :input_for_day2, pretty: true)
                                  |> get_directory_to_delete(total_disk_space: 70_000_000, update_size: 30_000_000)

    directory_to_delete.size
  end

  defp get_directory_to_delete(graph_with_sizes, opts) do
    total_disk_space = Keyword.get(opts, :total_disk_space, 70_000_000)
    update_size = Keyword.get(opts, :update_size, 30_000_000)
    IO.inspect(graph_with_sizes)
    %SystemNode{size: current_used_space} = get_vertex_by_node_name(graph_with_sizes, "root") |> IO.inspect

    current_free_space = total_disk_space - current_used_space
    space_to_free_up = update_size - current_free_space
    IO.puts(IO.ANSI.format([:light_blue_background, "TOTAL DISK SPACE #{total_disk_space} |\nSIZE REQUIRED BY UPDATE #{update_size} |\nCURRENTLY USED SPACE #{current_used_space} |\n CURRENT FREE SPACE #{current_free_space} |\nNEED TO FREE #{space_to_free_up}"]))

    Graph.vertices(graph_with_sizes) |> Enum.filter(fn %SystemNode{type: type, size: size} -> type == :dir && size >= space_to_free_up end)
    |> Enum.min_by(fn %SystemNode{size: size} -> size end)
    |> IO.inspect(label: :dir_to_remove)
  end
end
