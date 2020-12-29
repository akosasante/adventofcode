  defmodule Advent2020.Day20 do
    import Helpers.Shared, only: [log: 1]

    def part1(input) do
      log("Running 2020-20-P1-InputList")
#      tile_map = get_tile_map(input)
#      corner_tiles = get_corner_tiles(tile_map)
#      Enum.reduce(corner_tiles, 1, fn corner_tile, acc ->
#        String.to_integer(corner_tile) * acc
#      end)
    end

    def part1_optimized(input) do
      log("Running 2020-20-P1-InputListOptimized")
      "Not implemented"
    end

    def part1_stream(input_stream) do
      log("Running 2020-20-P1-InputStream")
      "Not implemented"
    end

    def part2(input) do
      log("Running 2020-20-P2-InputList")
      size_of_square_edges = :math.sqrt(input |> Enum.count) |> floor()
      tile_map = get_tile_map(input)
      corner_tiles = get_corner_tiles(tile_map)
      jigsaw = build_jigsaw(tile_map, corner_tiles, size_of_square_edges)
      "Not implemented"
    end

    def part2_optimized(input) do
      log("Running 2020-20-P2-InputListOptimized")
      "Not implemented"
    end

    def part2_stream(input_stream) do
      log("Running 2020-20-P2-InputStream")
      "Not implemented"
    end

    defp get_tile_map(tile_input) do
      Enum.reduce(tile_input, %{}, fn tile, tile_map ->
        [tile_id, tile_string] = Regex.run(~r/^Tile\s(\d+):(\X*)$/, tile, capture: :all_but_first)
        Map.put(tile_map, tile_id, tile_string |> String.split("\n", trim: true))
      end)
    end

    defp get_corner_tiles(tile_map) do
      Enum.reduce(tile_map, [], fn {tile_id, tile_array}, corner_tiles ->
        if (number_of_matching_tiles(tile_id, tile_map) == 2) do
          [tile_id | corner_tiles]
        else
          corner_tiles
        end
      end)
    end

    defp number_of_matching_tiles(tile_id, tile_map) do
      other_tiles = Enum.reject(tile_map, fn {k, v} -> k == tile_id end)
      Enum.count(other_tiles, fn {_, other_tile} -> are_matching_pieces?(other_tile, Map.get(tile_map, tile_id)) end)
    end

    defp are_matching_pieces?(tile_1, tile_2) do
      tile_1_edges = get_edges(tile_1)
      tile_2_edges = get_edges(tile_2)

      !MapSet.disjoint?(tile_1_edges, tile_2_edges)
    end

    defp get_edges(tile) do
      Enum.flat_map([:top, :bottom, :left, :right], fn edge -> get_edge(edge, tile) end)
#      |> IO.inspect
      |> MapSet.new()
    end

    defp get_edge(:top, tile) do
      top_edge = hd(tile)
      top_edge_reversed = String.reverse(top_edge)
      [top_edge, top_edge_reversed]
    end

    defp get_edge(:bottom, tile) do
      bottom_edge = List.last(tile)
      bottom_edge_reversed = String.reverse(bottom_edge)
      [bottom_edge, bottom_edge_reversed]
    end

    defp get_edge(:left, tile) do
      left_edge = Enum.map(tile, fn <<first::binary-size(1), rest::binary>> -> first end)
                  |> Enum.join("")
                  |> String.reverse()
      left_edge_reversed = String.reverse(left_edge)
      [left_edge, left_edge_reversed]
    end

    defp get_edge(:right, tile) do
      right_edge =
        Enum.map(tile, fn str ->
          str = String.reverse(str)
          <<first::binary-size(1), rest::binary>> = str
          first
        end)
        |> Enum.join("")
        |> String.reverse()
      right_edge_reversed = String.reverse(right_edge)
      [right_edge, right_edge_reversed]
    end

    defp build_jigsaw(tile_map, corner_ids, edge_length) do
      starting_corner = hd(corner_ids)
      coordinate_map = %{{1, 1} => starting_corner}
      Enum.reduce(1..edge_length, coordinate_map, fn row, coord_map_1 ->
        IO.inspect(coord_map_1, label: :coord1)
        Enum.reduce(1..edge_length, coord_map_1, fn col, coord_map_2 ->
          IO.puts("\nChecking #{inspect {row, col}}")
          IO.inspect(coord_map_2, label: :coord2)
          already_placed_tiles = Map.values(coord_map_2)
          cond do
            row == 1 and col == 1 ->
              # looking at starting position, which is already filled in, just skip
              coord_map_2
            (row == 1 and col == edge_length) or (row == edge_length and col == 1) or (row == edge_length and col == edge_length) ->
              # looking at a corner position, so we should definitely use a corner
              if col == 1 do
                # looking at bottom left corner, so we should match against above tile
                tile_above = Map.get(coord_map_2, {row - 1, col})
                other_tiles = Enum.filter(corner_ids, fn id -> id != tile_above and !Enum.member?(already_placed_tiles, id) end)
                matching_tiles = Enum.filter(other_tiles, fn tile_id -> are_matching_pieces?(Map.get(tile_map, tile_id), Map.get(tile_map, tile_above)) end)
                IO.puts("Looking for piece for {#{row}, #{col}} (corner piece).\nTile above=#{inspect tile_above}.\nMatching tiles:#{inspect matching_tiles}")
                Map.put(coord_map_2, {row, col}, hd(matching_tiles))
              else
                # looking at top/bottom right corner, so we should match against left tile
                tile_left = Map.get(coord_map_2, {row, col - 1})
                other_tiles = Enum.filter(corner_ids, fn id -> id != tile_left and !Enum.member?(already_placed_tiles, id) end)
                matching_tiles = Enum.filter(other_tiles, fn tile_id -> are_matching_pieces?(Map.get(tile_map, tile_id), Map.get(tile_map, tile_left)) end)
                IO.puts("Looking for piece for {#{row}, #{col}} (corner piece).\nTile left=#{inspect tile_left}.\nMatching tiles:#{inspect matching_tiles}")
                Map.put(coord_map_2, {row, col}, hd(matching_tiles))
              end
            col == 1 ->
              # looking at first position in row, find a tile to match the above tile
              tile_above = Map.get(coord_map_2, {row - 1, col})
              other_tiles = Enum.filter(tile_map, fn {k, v} -> k != tile_above and !Enum.member?(already_placed_tiles, k) and !Enum.member?(corner_ids, k) end)
              matching_tiles = Enum.filter(other_tiles, fn {tile_id, tile} -> are_matching_pieces?(tile, Map.get(tile_map, tile_above)) end)
              IO.puts("Looking for piece for {#{row}, #{col}}.\nTile above=#{inspect tile_above}.\nMatching tiles:#{inspect matching_tiles}")
              Map.put(coord_map_2, {row, col}, hd(matching_tiles) |> elem(0))
            true ->
              # looking at any other position in row, find a tile to match the left tile
              tile_left = Map.get(coord_map_2, {row, col - 1})
              other_tiles = Enum.filter(tile_map, fn {k, v} -> k != tile_left and !Enum.member?(already_placed_tiles, k) and !Enum.member?(corner_ids, k) end)
              matching_tiles = Enum.filter(other_tiles, fn {tile_id, tile} -> are_matching_pieces?(tile,Map.get(tile_map, tile_left)) end)
              IO.puts("Looking for piece for {#{row}, #{col}}.\nTile left=#{inspect tile_left}.\nMatching tiles:#{inspect matching_tiles}")
              Map.put(coord_map_2, {row, col}, hd(matching_tiles) |> elem(0))
          end
        end)
      end)
      # Enum.filter?(other_tiles, are_matching_pieces(curr_tile, other_tile))
      # Get are_matching_piecees to return which edge and orientation matched
      # pick the first one and put it at (row,col) of map after updating the tile based on orientation
      # print fnxn
    end
  end
