  defmodule Advent2020.Day20 do
    import Helpers.Shared, only: [log: 1]

    @edge_directions [:top, :right, :bottom, :left]

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
      size_of_jigsaw_edges = :math.sqrt(input |> Enum.count) |> floor()
      tile_map = get_tile_map(input)
      corner_tiles = get_corner_tiles(tile_map)
      size_of_tile_edges = Map.values(tile_map) |> List.first() |> List.first() |> String.length
      {jigsaw_coords, updated_tile_map} = build_jigsaw(tile_map, corner_tiles, size_of_jigsaw_edges, size_of_tile_edges)
      print_jigsaw(jigsaw_coords, updated_tile_map, size_of_jigsaw_edges)
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
      Enum.flat_map(@edge_directions, fn edge -> get_edge(edge, tile) end)
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
      right_edge_reversed = String.reverse(right_edge)
      [right_edge, right_edge_reversed]
    end

    defp build_jigsaw(tm, corner_ids, jigsaw_length, edge_length) do
      starting_corner = hd(corner_ids)
      Enum.reduce(1..jigsaw_length, {%{}, tm}, fn row, {coord_map_1, inner_tile_map} ->
        Enum.reduce(1..jigsaw_length, {coord_map_1, inner_tile_map}, fn col, {coord_map_2, tile_map} ->
          IO.puts("\nChecking #{inspect {row, col}}")
          IO.inspect(coord_map_2, label: :coord2)
          already_placed_tiles = Map.values(coord_map_2)
          cond do
            row == 1 and col == 1 ->
              # looking at starting position, use the first corner id in the list and make sure it's oriented correctly
              oriented_corner = orient_corner(starting_corner, tile_map, jigsaw_length, edge_length, [:top, :left], true)
              updated_coords = Map.put(coord_map_2, {row, col}, starting_corner)
              updated_tile_map = Map.put(tile_map, starting_corner, oriented_corner)
              {updated_coords, updated_tile_map}

            (row == 1 and col == jigsaw_length) ->
              # looking at top right corner, so find the corner from the list that matches the tile already placed left
              tile_left_id = Map.get(coord_map_2, {row, col - 1})
              tiles_matching_left_tile = get_matching_tiles(tile_left_id, tile_map)
              matching_corner_tile = Enum.find(tiles_matching_left_tile, fn id -> id in corner_ids and !Enum.member?(already_placed_tiles, id) end)
              IO.puts("Looking for piece for {#{row}, #{col}} (corner piece).\nTile left=#{inspect tile_left_id}.\nMatching corner tile:#{inspect matching_corner_tile}")

              oriented_corner = orient_corner(matching_corner_tile, tile_map, jigsaw_length, edge_length, [:top, :right])
              updated_coords = Map.put(coord_map_2, {row, col}, matching_corner_tile)
              updated_tile_map = Map.put(tile_map, matching_corner_tile, oriented_corner)
              {updated_coords, updated_tile_map}

            (row == jigsaw_length and col == 1) ->
              # looking at bottom left corner, so find the corner from the list that matches the tile already placed above
              tile_above_id = Map.get(coord_map_2, {row - 1, col})
              tiles_matching_above_tile = get_matching_tiles(tile_above_id, tile_map)
              matching_corner_tile = Enum.find(tiles_matching_above_tile, fn id -> id in corner_ids and !Enum.member?(already_placed_tiles, id) end)

              IO.puts("Looking for piece for {#{row}, #{col}} (corner piece).\nTile above=#{inspect tile_above_id}.\nMatching corner tile:#{inspect matching_corner_tile}")

              oriented_corner = orient_corner(matching_corner_tile, tile_map, jigsaw_length, edge_length, [:bottom, :left])
              updated_coords = Map.put(coord_map_2, {row, col}, matching_corner_tile)
              updated_tile_map = Map.put(tile_map, matching_corner_tile, oriented_corner)
              {updated_coords, updated_tile_map}

            (row == jigsaw_length and col == jigsaw_length) ->
              # looking at bottom right corner, so find the remaining from the list.
              remaining_corner = Enum.find(corner_ids, fn id -> !Enum.member?(already_placed_tiles, id) end)

              IO.puts("Looking for piece for {#{row}, #{col}} (corner piece).\nRemaining corner tile:#{inspect remaining_corner}")

              oriented_corner = orient_corner(remaining_corner, tile_map, jigsaw_length, edge_length, [:bottom, :right])
              updated_coords = Map.put(coord_map_2, {row, col}, remaining_corner)
              updated_tile_map = Map.put(tile_map, remaining_corner, oriented_corner)
              {updated_coords, updated_tile_map}

            true ->
              # looking at any other position in row, find a tile to match the top/left tile
              tile_above_id =  Map.get(coord_map_2, {row - 1, col}, nil)
              tile_left_id = Map.get(coord_map_2, {row, col - 1}, nil)
              tiles_to_match = Enum.reject([tile_above_id, tile_left_id], &is_nil/1)

              IO.puts("Looking for piece for {#{row}, #{col}}.\nTiles to match=#{inspect tiles_to_match}.")
              tiles_matching_above_and_left = get_matching_tiles(tiles_to_match, tile_map)
                                             |> IO.inspect(label: :all_tiles_matching)
                                             |> Enum.reject(fn id -> id in Map.values(coord_map_2) end)
              IO.puts("Matching tiles:#{inspect tiles_matching_above_and_left}")

              correct_tile_id = cond do
                is_nil(tile_above_id) ->
                  IO.puts("Looking for tile that matches to the left one")
                  left_tile = Map.get(tile_map, tile_left_id)
                  Enum.find(tiles_matching_above_and_left, fn id ->
                    case get_matching_edges(left_tile, Map.get(tile_map, id)) do
                      [{:right, _, _}] -> true
                      _ -> false
                    end
                  end)
                true -> List.first(tiles_matching_above_and_left)
              end |> IO.inspect(label: :correct_tile_id)

              oriented_tile = orient_tile({correct_tile_id, Map.get(tile_map, correct_tile_id)}, Map.get(tile_map, tile_above_id), Map.get(tile_map, tile_left_id), edge_length)
              updated_coords = Map.put(coord_map_2, {row, col}, correct_tile_id)
              updated_tile_map = Map.put(tile_map, correct_tile_id, oriented_tile)
              {updated_coords, updated_tile_map}
          end
        end)
      end)
    end

    defp print_jigsaw(jigsaw_coords, tile_map, edge_length) do
      tile_height = Enum.at(tile_map, 0) |> elem(1) |> Enum.count()
      Enum.reduce(1..edge_length, "", fn row, whole_str ->
        r = Enum.map_join(0..(tile_height - 1), "\n", fn tile_row ->
          Enum.map_join(1..edge_length, " ", fn col ->
            tile_id = Map.get(jigsaw_coords, {row, col})
            tile = Map.get(tile_map, tile_id)
            Enum.at(tile, tile_row)
          end)
        end)
        "#{whole_str}\n\n#{r}"
      end)
      |> IO.puts
    end

    defp get_matching_edges(edge, tile) when is_binary(edge) do
      for dir <- @edge_directions do
        [tile_edge, reverse_edge] = get_edge(dir, tile) |> IO.inspect
        cond do
          tile_edge == edge -> {dir, false}
          reverse_edge == edge -> {dir, true}
          true -> nil
        end
      end
      |> Enum.reject(&is_nil/1)
    end

    defp get_matching_edges(tile1, tile2) when is_list(tile1) and is_list(tile2) do
      for dir1 <- @edge_directions,
          dir2 <- @edge_directions do
        [edge1, reverse_edge1] = get_edge(dir1, tile1)
        [edge2, _] = get_edge(dir2, tile2)

        cond do
          dir1 == dir2 and edge1 == edge2 -> {dir1, dir2, true}
          dir1 != dir2 and edge1 == edge2 -> {dir1, dir2, false}
          # top and top match, the second top will need to rotate to bottom and then be flipped
          # top_r and top match, the second top only needs to rotate to bottom
          # top and left match, left only needs to rotate to bottom
          # top_r and left match, left needs to rotate to bottom and flip
          # top and bottom match, bottom needs to rotate (0)
          # top_r and bottom match, bottom needs to rotate (0) and flip
          # top and right match, right needs to rotate to bottom and flip
          # top_r and right match, right only needs to rotate to bottom
          true -> nil
        end
      end
      |> Enum.reject(&is_nil/1)
      todo: goals, and keybase
    end

    # returns a list of tile_ids that can be pieced with the given tile_id
    def get_matching_tiles(tile_ids, tile_map) when is_list(tile_ids) do
      Enum.reduce(tile_ids, [], fn tile_id, matching_ids ->
        case matching_ids do
          [] -> get_matching_tiles(tile_id, tile_map)
          _ ->
            remaining_map = Map.take(tile_map, [tile_id | matching_ids])
            get_matching_tiles(tile_id, remaining_map)
        end
      end)
    end

    def get_matching_tiles(tile_id, tile_map) do
      tile_map
      |> Map.delete(tile_id)
      |> Enum.filter(fn {other_tile_id, other_tile} -> are_matching_pieces?(other_tile, Map.get(tile_map, tile_id)) end)
      |> Enum.map(fn {other_tile_id, _} -> other_tile_id end)
    end

    def orient_corner(corner_piece_id, tile_map, jigsaw_length, edge_length, corner_orientation, skip_flip \\ false) do
      IO.puts "Orienting corner piece #{inspect corner_piece_id} on a #{jigsaw_length}x#{jigsaw_length} board with #{edge_length}x#{edge_length} tiles. Trying to face the non-matching pieces: #{inspect corner_orientation}"

      corner_piece = Map.get(tile_map, corner_piece_id) |> IO.inspect(label: :tile_to_orient)
      matching_tile_ids = get_matching_tiles(corner_piece_id, tile_map) |> IO.inspect(label: :matching_tile_ids)
      matching_pieces = Enum.map(matching_tile_ids, fn id -> Map.get(tile_map, id) end) |> IO.inspect(label: :matching_tiles)
      non_matching_edges = get_non_matching_edges(corner_piece, matching_pieces) |> IO.inspect(label: :non_matching_edges)
      min_non_matching_edge = Enum.min_by(non_matching_edges, fn non_matching_edge -> Enum.find_index(@edge_directions, fn dir -> dir == non_matching_edge end) end)
      rotated_tile = if non_matching_edges == corner_orientation or non_matching_edges == Enum.reverse(corner_orientation) do
        IO.puts "no need to rotate"
        corner_piece
      else
        destination_edge =
          case corner_orientation do
            [:top, :left] -> :left
            [:top, :right] -> :top
            [:bottom, :left] -> :bottom
            [:bottom, :right] -> :right
          end
        rotate_tile(corner_piece, edge_length, min_non_matching_edge, destination_edge)
      end

      if skip_flip do
        IO.puts "skipping flip"
        rotated_tile
      else
        matching_edges = Enum.flat_map(matching_pieces, fn tile -> get_matching_edges(rotated_tile, tile) end) |> IO.inspect(label: :matching_edges_for_flip)
        flipped_edges =  Enum.filter(matching_edges, fn {_, _, flip} -> flip end) |> IO.inspect(label: :flipped_edges)
        if Enum.count(flipped_edges) == 1 do
          [{side, _, _}] = flipped_edges
          case side do
            :top -> flip_tile(rotated_tile, edge_length, :horizontal)
            :bottom -> flip_tile(rotated_tile, edge_length, :horizontal)
            :left -> flip_tile(rotated_tile, edge_length, :vertical)
            :right -> flip_tile(rotated_tile, edge_length, :vertical)
          end
        else
          rotated_tile
        end
      end |> IO.inspect(label: :final_orientation)
    end

    def orient_tile({tile_id, tile}, nil, left_tile, edge_length) do
      IO.puts "Orienting non-corner piece  #{inspect tile_id} on the first row of a board with #{edge_length}x#{edge_length} tiles. Trying to face left tile #{inspect left_tile}"

      [{:right, edge_for_left_tile, is_flipped?}] = get_matching_edges(left_tile, tile) |> IO.inspect(label: :edge_for_left)
      rotated_for_left = rotate_tile(tile, edge_length, edge_for_left_tile, :left) |> IO.inspect(label: :rotated_for_left)

      if is_flipped? do
        flip_tile(rotated_for_left, edge_length, :vertical)
      else
        rotated_for_left
      end |> IO.inspect(label: :oriented_tile)
    end

    def orient_tile({tile_id, tile}, top_tile, nil, edge_length) do
      IO.puts "Orienting non-corner piece  #{inspect tile_id} on the first column of a board with #{edge_length}x#{edge_length} tiles. Trying to face top tile #{inspect top_tile}"

      [{:bottom, edge_for_top_tile, is_flipped?}] = get_matching_edges(top_tile, tile) |> IO.inspect(label: :edge_for_top)
      rotated_for_top = rotate_tile(tile, edge_length, edge_for_top_tile, :top) |> IO.inspect(label: :rotated_for_top)

      if is_flipped? do
        flip_tile(rotated_for_top, edge_length, :horizontal)
      else
        rotated_for_top
      end |> IO.inspect(label: :oriented_tile)
    end

    def orient_tile({tile_id, tile}, top_tile, left_tile, edge_length) do
      IO.puts "Orienting non-corner piece #{inspect tile_id} on a board with #{edge_length}x#{edge_length} tiles. Trying to face top tile #{inspect top_tile} and left tile #{inspect left_tile}"

      [{:bottom, edge_for_top_tile, is_flipped?}] = get_matching_edges(top_tile, tile) |> IO.inspect(label: :edge_for_top)
      rotated_for_top = rotate_tile(tile, edge_length, edge_for_top_tile, :top) |> IO.inspect(label: :rotated_for_top)

      edge_for_left_tile = get_matching_edges(rotated_for_top, left_tile) |> IO.inspect(label: :edge_for_left)
      flipped_for_left = case edge_for_left_tile do
        :left -> rotated_for_top
        :right -> flip_tile(rotated_for_top, edge_length, :horizontal)
        _ -> raise "Unexpectedly found a tile that was not on the left or right of the tile: #{inspect tile_id}"
      end |> IO.inspect(label: :oriented_tile)

      flipped_for_left
    end

    def rotate_tile(tile, edge_length, starting_orientation, ending_orientation) do
      IO.puts "Changing orientation from #{inspect starting_orientation} to #{inspect ending_orientation}"
      s = Enum.find_index(@edge_directions, &(&1 == starting_orientation))
      d = Enum.find_index(@edge_directions, &(&1 == ending_orientation))

      rotate_amt = d - s
      rotate_tile(tile, rotate_amt, edge_length)
    end

    def rotate_tile(tile, 0, _), do: tile
    def rotate_tile(tile, rotate_amt, edge_length) when rotate_amt > 0 do
      IO.puts "rotating clockwise"
      Enum.map(0..(edge_length - 1), fn col ->
        Enum.map_join((edge_length - 1)..0, fn row ->
          Enum.at(tile, row)
          |> String.at(col)
        end)
      end)
      |> rotate_tile(rotate_amt - 1, edge_length)
    end
    def rotate_tile(tile, rotate_amt, edge_length) when rotate_amt < 0 do
      IO.puts "rotating anti-clockwise"
      Enum.map((edge_length - 1)..0, fn col ->
        Enum.map_join(0..(edge_length - 1), fn row ->
          Enum.at(tile, row)
          |> String.at(col)
        end)
      end)
      |> rotate_tile(rotate_amt + 1, edge_length)
    end

    def flip_tile(tile, edge_length, :horizontal) do
      Enum.map(0..(edge_length - 1), fn row ->
        Enum.map_join((edge_length - 1)..0, fn col ->
          Enum.at(tile, row)
          |> String.at(col)
        end)
      end)
    end

    def flip_tile(tile, edge_length, :vertical) do
      Enum.map((edge_length - 1)..0, fn row ->
        Enum.map_join(0..(edge_length - 1), fn col ->
          Enum.at(tile, row)
          |> String.at(col)
        end)
      end)
    end

    def get_non_matching_edges(corner_tile, matching_tiles) do
      matching_edges = for matching_tile <- matching_tiles do
        get_matching_edges(corner_tile, matching_tile)
      end
      |> List.flatten
      |> Enum.map(fn {corner_edge, _, _} -> corner_edge end)

      @edge_directions -- matching_edges
    end

  end
