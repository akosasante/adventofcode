defmodule Advent2022.Day5 do
  require Logger

  @length_of_crate_chars 3
  @spaces_between_crates_chars Range.new(0, 1)
  @move_regex ~r/move (?<num_crates_to_move>\d+) from (?<start_col>\d+) to (?<destination_col>\d+)/
  @part_1_mover :cm_9000
  @part_2_mover :cm_9001

  def part1(input) do
    Logger.info("Running 2022-5-P1-InputList")
    {moves, stacks, [num_stacks_line]} = input
                                         |> split_input()

    num_stacks = get_num_stacks(num_stacks_line)
                 |> IO.inspect

    crates = parse_starting_stacks(stacks, num_stacks)
             |> IO.inspect

    calculate_moves(crates, moves, @part_1_mover)
    |> get_top_crates()
    |> IO.inspect(label: :input_for_day1, pretty: true)
  end

  defp split_input(input) do
    {moves, rest_of_input} = Enum.split_with(input, fn line -> String.starts_with?(line, "move") end)
    {num_stacks, stacks} = Enum.split_with(rest_of_input, fn line -> String.starts_with?(line, " 1") end)
    {moves, stacks, num_stacks}
  end

  defp get_num_stacks(num_stacks_line) do
    num_stacks_line
    |> String.trim()
    |> String.slice(-1..-1)
    |> String.to_integer()
  end

  defp parse_starting_stacks(stacks, num_expected_stacks) do
    starting_stacks_regex = calculate_regex_for_parsing_stacks()

    Enum.reduce(
      stacks,
      List.duplicate([], num_expected_stacks),
      fn stack_row_str, stacks_list ->
        crates = parse_stack_row(stack_row_str, starting_stacks_regex)
        for {crate, col} <- Enum.zip(crates, stacks_list) do
          case crate do
            nil -> col
            [crate_item] -> [crate_item | col]
          end
        end
      end
    )
    |> Enum.map(&Enum.reverse/1)
  end

  defp calculate_regex_for_parsing_stacks() do
    min_space_between_crates..max_space_between_crates = @spaces_between_crates_chars
    regex_spaces_between_crate_chars = ".{#{min_space_between_crates},#{max_space_between_crates}}"
    regex_stack_characters = ".{#{@length_of_crate_chars}}"
    Regex.compile!("(#{regex_stack_characters})#{regex_spaces_between_crate_chars}")
  end

  defp parse_stack_row(stack_row_str, regex) do
    regex
    |> Regex.scan(stack_row_str, capture: :all_but_first)
    |> List.flatten
    |> Enum.map(fn str -> Regex.run(~r/\[(\w)\]/, str, capture: :all_but_first) end)
  end

  defp calculate_moves(crates, moves, mover_type \\ @part_1_mover) do
    Enum.reduce(moves, crates, &perform_move(&1, &2, mover_type))
  end

  defp perform_move(move, crates_before_move, mover_type) do
    %{
      "num_crates_to_move" => num_crates_to_move,
      "start_col" => start_col,
      "destination_col" => destination_col
    } = parse_move(move)
    num_crates_to_move = String.to_integer(num_crates_to_move)
    starting_col_index = String.to_integer(start_col) - 1
    destination_col_index = String.to_integer(destination_col) - 1

    case mover_type do
      @part_1_mover -> perform_move_part_1(num_crates_to_move, crates_before_move, starting_col_index, destination_col_index)
      @part_2_mover -> perform_move_part_2(num_crates_to_move, crates_before_move, starting_col_index, destination_col_index)
    end
  end

  defp perform_move_part_1(num_crates_to_move, crates_before_move, starting_col_index, destination_col_index) do
    Enum.reduce(
      1..num_crates_to_move,
      crates_before_move,
      fn _move_num, crates_after_move ->
        [removed_crate | remaining_starting_col] = Enum.at(crates_after_move, starting_col_index)
        new_destination_col = [removed_crate | Enum.at(crates_after_move, destination_col_index)]


        crates_after_move
        |> List.update_at(starting_col_index, fn _ -> remaining_starting_col end)
        |> List.update_at(destination_col_index, fn _ -> new_destination_col end)
      end
    )
  end

  defp parse_move(move) do
    Regex.named_captures(@move_regex, move)
  end

  defp get_top_crates(stacks) do
    Enum.map(stacks, &hd/1)
    |> Enum.join()
  end

  def part2(input) do
    Logger.info("Running 2022-5-P2-InputList")

    {moves, stacks, [num_stacks_line]} = input
                                         |> split_input()

    num_stacks = get_num_stacks(num_stacks_line)
                 |> IO.inspect

    crates = parse_starting_stacks(stacks, num_stacks)
             |> IO.inspect

    calculate_moves(crates, moves, @part_2_mover)
    |> get_top_crates()
    |> IO.inspect(label: :input_for_day2, pretty: true)
  end

  defp perform_move_part_2(num_crates_to_move, crates_before_move, starting_col_index, destination_col_index) do
    starting_col = Enum.at(crates_before_move, starting_col_index)
    destination_col = Enum.at(crates_before_move, destination_col_index)

    {crates_to_move, remaining_starting_col} = Enum.split(starting_col, num_crates_to_move)
    new_destination_col = crates_to_move ++ destination_col

    crates_before_move
    |> List.update_at(starting_col_index, fn _ -> remaining_starting_col end)
    |> List.update_at(destination_col_index, fn _ -> new_destination_col end)
  end
end
