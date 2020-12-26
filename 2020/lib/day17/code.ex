  defmodule Advent2020.Day17 do
    import Helpers.Shared, only: [log: 1]

    @check_positions [
      {-1, 1, 0}, {0, 1, 0}, {1, 1, 0}, {1, 0, 0}, {1, -1, 0}, {0, -1, 0}, {-1, -1, 0}, {-1, 0, 0},
      {-1, 1, -1}, {0, 1, -1}, {1, 1, -1}, {1, 0, -1}, {1, -1, -1}, {0, -1, -1}, {-1, -1, -1}, {-1, 0, -1}, {0, 0, -1},
      {-1, 1, 1}, {0, 1, 1}, {1, 1, 1}, {1, 0, 1}, {1, -1, 1}, {0, -1, 1}, {-1, -1, 1}, {-1, 0, 1}, {0, 0, 1}
    ]

    @check_positions_2 [
      {-1, -1, -1, -1}, {-1, -1, -1, 0}, {-1, -1, -1, 1}, {-1, -1, 0, -1}, {-1, -1, 0, 0}, {-1, -1, 0, 1}, {-1, -1, 1, -1}, {-1, -1, 1, 0}, {-1, -1, 1, 1}, {-1, 0, -1, -1}, {-1, 0, -1, 0}, {-1, 0, -1, 1}, {-1, 0, 0, -1}, {-1, 0, 0, 0}, {-1, 0, 0, 1}, {-1, 0, 1, -1}, {-1, 0, 1, 0}, {-1, 0, 1, 1}, {-1, 1, -1, -1}, {-1, 1, -1, 0}, {-1, 1, -1, 1}, {-1, 1, 0, -1}, {-1, 1, 0, 0}, {-1, 1, 0, 1}, {-1, 1, 1, -1}, {-1, 1, 1, 0}, {-1, 1, 1, 1}, {0, -1, -1, -1}, {0, -1, -1, 0}, {0, -1, -1, 1}, {0, -1, 0, -1}, {0, -1, 0, 0}, {0, -1, 0, 1}, {0, -1, 1, -1}, {0, -1, 1, 0}, {0, -1, 1, 1}, {0, 0, -1, -1}, {0, 0, -1, 0}, {0, 0, -1, 1}, {0, 0, 0, -1}, {0, 0, 0, 1}, {0, 0, 1, -1}, {0, 0, 1, 0}, {0, 0, 1, 1}, {0, 1, -1, -1}, {0, 1, -1, 0}, {0, 1, -1, 1}, {0, 1, 0, -1}, {0, 1, 0, 0}, {0, 1, 0, 1}, {0, 1, 1, -1}, {0, 1, 1, 0}, {0, 1, 1, 1}, {1, -1, -1, -1}, {1, -1, -1, 0}, {1, -1, -1, 1}, {1, -1, 0, -1}, {1, -1, 0, 0}, {1, -1, 0, 1}, {1, -1, 1, -1}, {1, -1, 1, 0}, {1, -1, 1, 1}, {1, 0, -1, -1}, {1, 0, -1, 0}, {1, 0, -1, 1}, {1, 0, 0, -1}, {1, 0, 0, 0}, {1, 0, 0, 1}, {1, 0, 1, -1}, {1, 0, 1, 0}, {1, 0, 1, 1}, {1, 1, -1, -1}, {1, 1, -1, 0}, {1, 1, -1, 1}, {1, 1, 0, -1}, {1, 1, 0, 0}, {1, 1, 0, 1}, {1, 1, 1, -1}, {1, 1, 1, 0}, {1, 1, 1, 1}
    ]



    def part1(input) do
      log("Running 2020-17-P1-InputList")
      # run cycle for 6 generations
      input
      |> parse_input()
      |> print()
      |> run_cycles(6)
#      |> print()
      |> get_active_cubes()
    end

    def part1_optimized(input) do
      log("Running 2020-17-P1-InputListOptimized")
      "Not implemented"
    end

    def part1_stream(input_stream) do
      log("Running 2020-17-P1-InputStream")
      "Not implemented"
    end

    def part2(input) do
      log("Running 2020-17-P2-InputList")
      input
      |> parse_input_2()
      |> print_2()
      |> run_cycles_2(6)
        #      |> print()
      |> get_active_cubes()
    end

    def part2_optimized(input) do
      log("Running 2020-17-P2-InputListOptimized")
      "Not implemented"
    end

    def part2_stream(input_stream) do
      log("Running 2020-17-P2-InputStream")
      "Not implemented"
    end

    defp parse_input(input) do
      Enum.reduce(Enum.with_index(input), Map.new(), fn {row, row_index}, grid ->
        grid_row_coords =
          row
          |> String.split("", trim: true)
          |> Enum.with_index()
          |> Enum.map(fn {cube, col_index} -> {{col_index, -row_index, 0}, is_cube_active?(cube)} end)
          |> Map.new()
        Map.merge(grid, grid_row_coords)
      end)
    end

    defp parse_input_2(input) do
      Enum.reduce(Enum.with_index(input), Map.new(), fn {row, row_index}, grid ->
        grid_row_coords =
          row
          |> String.split("", trim: true)
          |> Enum.with_index()
          |> Enum.map(fn {cube, col_index} -> {{col_index, -row_index, 0, 0}, is_cube_active?(cube)} end)
          |> Map.new()
        Map.merge(grid, grid_row_coords)
      end)
    end

    defp run_cycles(grid, num_cycles) do
      Enum.reduce(1..num_cycles, grid, &run_cycle/2)
    end

    defp run_cycles_2(grid, num_cycles) do
      Enum.reduce(1..num_cycles, grid, &run_cycle_2/2)
    end

    # grid is a map where the keys are 3-d coordinates and the value
    # is whether the cube at that coord is active or not
    defp run_cycle(cycle, grid) do
      log("Running cycle: #{cycle}")
      new_grid =
        grid
        |> add_edge_x_y_cells()
#        |> print()
        |> add_top_bottom_z_layers()
#        |> print()
        |> Enum.map(fn {coord, cube} ->
          new_cube = check_neighbours_and_return_cube(coord, cube, grid)
          {coord, new_cube}
        end)
        |> Map.new()
        |> print()
    end

    defp run_cycle_2(cycle, grid) do
      log("Running cycle: #{cycle}")
      new_grid =
        grid
        |> add_edge_x_y_cells_2()
          #        |> print()
        |> add_top_bottom_z_layers_2()
          #        |> print()
        |> add_w_layers()
        |> Enum.map(fn {coord, cube} ->
          new_cube = check_neighbours_and_return_cube(coord, cube, grid)
          {coord, new_cube}
        end)
        |> Map.new()
        |> print_2()
    end

    defp check_neighbours_and_return_cube(coord, true, grid) do
      surrounding_active_cells(coord, grid) in 2..3
    end

    defp check_neighbours_and_return_cube(coord, false, grid) do
      surrounding_active_cells(coord, grid) == 3
    end

    defp surrounding_active_cells({x, y, z}, grid) do
      for {check_x, check_y, check_z} <- @check_positions, reduce: 0 do
        sum_of_active_cubes ->
          coord_to_check = {x + check_x, y + check_y, z + check_z}
          cube_at_coord_to_check = Map.get(grid, coord_to_check, false)
#          log("For #{inspect {x, y, z}}, checking #{inspect coord_to_check}. Res: #{is_cube_active?(cube_at_coord_to_check)}")
          if is_cube_active?(cube_at_coord_to_check), do: sum_of_active_cubes + 1, else: sum_of_active_cubes
      end
    end

    defp surrounding_active_cells({x, y, z, w}, grid) do
      for {check_x, check_y, check_z, check_w} <- @check_positions_2, reduce: 0 do
        sum_of_active_cubes ->
          coord_to_check = {x + check_x, y + check_y, z + check_z, w + check_w}
          cube_at_coord_to_check = Map.get(grid, coord_to_check, false)
#         log("For #{inspect {x, y, z}}, checking #{inspect coord_to_check}. Res: #{is_cube_active?(cube_at_coord_to_check)}")
          if is_cube_active?(cube_at_coord_to_check), do: sum_of_active_cubes + 1, else: sum_of_active_cubes
      end
    end

    def is_cube_active?(true), do: true
    def is_cube_active?("#"), do: true
    def is_cube_active?(false), do: false
    def is_cube_active?("."), do: false

    defp add_top_bottom_z_layers(grid) do
      {{{_, _, min_z}, _}, {{_, _, max_z}, _}} = Enum.min_max_by(grid, fn {{_, _, z}, _} -> z end)
      bottom_layer =
        grid
        |> Enum.filter(fn {{_, _, z}, _} -> z == min_z end)
        |> Enum.map(fn {{x, y, z}, _} -> {{x, y , z - 1}, false} end)
        |> Map.new()

      top_layer =
        grid
        |> Enum.filter(fn {{_, _, z}, _} -> z == max_z end)
        |> Enum.map(fn {{x, y, z}, _} -> {{x, y , z + 1}, false} end)
        |> Map.new()

      Map.merge(grid, bottom_layer) |> Map.merge(top_layer)
    end

    defp add_top_bottom_z_layers_2(grid) do
      {{{_, _, min_z, _}, _}, {{_, _, max_z, _}, _}} = Enum.min_max_by(grid, fn {{_, _, z, _}, _} -> z end)
      bottom_layer =
        grid
        |> Enum.filter(fn {{_, _, z, _}, _} -> z == min_z end)
        |> Enum.map(fn {{x, y, z, w}, _} -> {{x, y , z - 1, w}, false} end)
        |> Map.new()

      top_layer =
        grid
        |> Enum.filter(fn {{_, _, z, _}, _} -> z == max_z end)
        |> Enum.map(fn {{x, y, z, w}, _} -> {{x, y , z + 1, w}, false} end)
        |> Map.new()

      Map.merge(grid, bottom_layer) |> Map.merge(top_layer)
    end

    defp add_edge_x_y_cells(grid) do
      {{{min_x, _, _}, _}, {{max_x, _, _}, _}} = Enum.min_max_by(grid, fn {{x, _, _}, _} -> x end)
      {{{_, min_y, _}, _}, {{_, max_y, _}, _}} = Enum.min_max_by(grid, fn {{_, y, _}, _} -> y end)

      left_layer =
        grid
        |> Enum.filter(fn {{x, _, _}, _} -> x == min_x end)
        |> Enum.map(fn {{x, y, z}, _} -> {{x - 1, y , z}, false} end)
        |> Map.new()


      right_layer =
        grid
        |> Enum.filter(fn {{x, _, _}, _} -> x == max_x end)
        |> Enum.map(fn {{x, y, z}, _} -> {{x + 1, y , z}, false} end)
        |> Map.new()

      up_layer =
        Map.merge(grid, left_layer) |> Map.merge(right_layer)
        |> Enum.filter(fn {{_, y, _}, _} -> y == min_y end)
        |> Enum.map(fn {{x, y, z}, _} -> {{x, y - 1, z}, false} end)
        |> Map.new()

      down_layer =
        Map.merge(grid, left_layer) |> Map.merge(right_layer)
        |> Enum.filter(fn {{_, y, _}, _} -> y == max_y end)
        |> Enum.map(fn {{x, y, z}, _} -> {{x, y + 1, z}, false} end)
        |> Map.new()

      grid
      |> Map.merge(left_layer)
      |> Map.merge(right_layer)
      |> Map.merge(up_layer)
      |> Map.merge(down_layer)
    end

    defp add_edge_x_y_cells_2(grid) do
      {{{min_x, _, _, _}, _}, {{max_x, _, _, _}, _}} = Enum.min_max_by(grid, fn {{x, _, _, _}, _} -> x end)
      {{{_, min_y, _, _}, _}, {{_, max_y, _, _}, _}} = Enum.min_max_by(grid, fn {{_, y, _, _}, _} -> y end)

      left_layer =
        grid
        |> Enum.filter(fn {{x, _, _, _}, _} -> x == min_x end)
        |> Enum.map(fn {{x, y, z, w}, _} -> {{x - 1, y , z, w}, false} end)
        |> Map.new()


      right_layer =
        grid
        |> Enum.filter(fn {{x, _, _, _}, _} -> x == max_x end)
        |> Enum.map(fn {{x, y, z, w}, _} -> {{x + 1, y , z, w}, false} end)
        |> Map.new()

      up_layer =
        Map.merge(grid, left_layer) |> Map.merge(right_layer)
        |> Enum.filter(fn {{_, y, _, _}, _} -> y == min_y end)
        |> Enum.map(fn {{x, y, z, w}, _} -> {{x, y - 1, z, w}, false} end)
        |> Map.new()

      down_layer =
        Map.merge(grid, left_layer) |> Map.merge(right_layer)
        |> Enum.filter(fn {{_, y, _, _}, _} -> y == max_y end)
        |> Enum.map(fn {{x, y, z, w}, _} -> {{x, y + 1, z, w}, false} end)
        |> Map.new()

      grid
      |> Map.merge(left_layer)
      |> Map.merge(right_layer)
      |> Map.merge(up_layer)
      |> Map.merge(down_layer)
    end

    defp add_w_layers(grid) do
      {{{_, _, _, min_w}, _}, {{_, _, _, max_w}, _}} = Enum.min_max_by(grid, fn {{_, _, _, w}, _} -> w end)
      neg_layer =
        grid
        |> Enum.filter(fn {{_, _, _, w}, _} -> w == min_w end)
        |> Enum.map(fn {{x, y, z, w}, _} -> {{x, y , z, w - 1}, false} end)
        |> Map.new()

      pos_layer =
        grid
        |> Enum.filter(fn {{_, _, _, w}, _} -> w == max_w end)
        |> Enum.map(fn {{x, y, z, w}, _} -> {{x, y , z, w + 1}, false} end)
        |> Map.new()

      Map.merge(grid, neg_layer) |> Map.merge(pos_layer)
    end

    defp print(grid) do
      grid_by_z_layer = Enum.group_by(grid, fn {{_, _, z}, _} -> z end)
      z_layers = Map.keys(grid_by_z_layer) |> Enum.sort()
      Enum.each(z_layers, fn layer ->
        log("Printing z=#{layer}")
        grid_by_y_layer = Enum.group_by(grid_by_z_layer[layer], fn {{_, y, _}, _} -> y end)
        y_layers = Map.keys(grid_by_y_layer) |> Enum.sort(:desc)
        Enum.each(y_layers, fn y_layer ->
          sorted_row = Enum.sort_by(grid_by_y_layer[y_layer], fn {{x, _, _}, _} -> x end)
          row = Enum.map(sorted_row, fn
            {{_, _, _}, true} -> "#"
            {{_, _, _}, false} -> "."
          end)
          |> Enum.join(" ")
          log("#{String.pad_leading(Integer.to_string(y_layer), 2)} #{row}")
        end)
      end)
      log("==========\n")
      grid
    end

    defp print_2(grid) do
      grid_by_zw_layer = Enum.group_by(grid, fn {{_, _, z, w}, _} -> {z, w} end)
      zw_layers = Map.keys(grid_by_zw_layer) |> Enum.sort()
      Enum.each(zw_layers, fn layer ->
        log("Printing {z, w}=#{inspect layer}")
        grid_by_y_layer = Enum.group_by(grid_by_zw_layer[layer], fn {{_, y, _, _}, _} -> y end)
        y_layers = Map.keys(grid_by_y_layer) |> Enum.sort(:desc)
        Enum.each(y_layers, fn y_layer ->
          sorted_row = Enum.sort_by(grid_by_y_layer[y_layer], fn {{x, _, _, _}, _} -> x end)
          row = Enum.map(sorted_row, fn
            {{_, _, _, _}, true} -> "#"
            {{_, _, _, _}, false} -> "."
          end)
                |> Enum.join(" ")
          log("#{String.pad_leading(Integer.to_string(y_layer), 2)} #{row}")
        end)
      end)
      log("==========\n")
      grid
    end

    defp get_active_cubes(grid) do
      Enum.count(grid,
        fn {_coord, cell} -> cell == true end)
    end
  end
