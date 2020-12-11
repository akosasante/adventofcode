defmodule Advent2020.Day8 do
  import Helpers.Shared, only: [log: 1]

  def part1(input) do
    log("Running 2020-8-P1-InputList")

    input
    |> Enum.map(&parse_instruction/1)
    |> Enum.with_index()
    |> run_program(0, 0, MapSet.new())
  end

  def part1_optimized(input) do
    log("Running 2020-8-P1-InputListOptimized")
    "Not implemented"
  end

  def part1_stream(input_stream) do
    log("Running 2020-8-P1-InputStream")
    "Not implemented"
  end

  def part2(input) do
    log("Running 2020-8-P2-InputList")

    input
    |> Enum.map(&parse_instruction/1)
    |> Enum.with_index()
    |> part_2_reducer()
  end

  def part2_optimized(input) do
    log("Running 2020-8-P2-InputListOptimized")
    "Not implemented"
  end

  def part2_stream(input_stream) do
    log("Running 2020-8-P2-InputStream")
    "Not implemented"
  end

  defp parse_instruction(instruction_string) do
    pattern = ~r/^(\w+) ([+|-]\d+)$/
    [instruction, value] = Regex.run(pattern, instruction_string, capture: :all_but_first)
    {instruction, String.to_integer(value)}
  end

  defp run_program(instructions_list, accumulator_value, index_to_run, visited_set) do
    if MapSet.member?(visited_set, index_to_run) do
      accumulator_value
    else
      visited_set = MapSet.put(visited_set, index_to_run)
      {{instruction, value}, index} = Enum.at(instructions_list, index_to_run)

      case instruction do
        "nop" ->
          run_program(instructions_list, accumulator_value, index_to_run + 1, visited_set)

        "acc" ->
          run_program(instructions_list, accumulator_value + value, index_to_run + 1, visited_set)

        "jmp" ->
          run_program(instructions_list, accumulator_value, index_to_run + value, visited_set)
      end
    end
  end

  defp part_2_reducer(instructions_list) do
    jmp_or_nop =
      instructions_list
      |> Enum.filter(fn {{instruction, _}, _} -> instruction in ["jmp", "nop"] end)

    Enum.reduce_while(jmp_or_nop, 0, fn {_, index_to_swap}, accumulator_value ->
      case run_program_p2(instructions_list, 0, 0, index_to_swap, MapSet.new()) do
        {:loop, _} -> {:cont, accumulator_value}
        {:end, acc} -> {:halt, acc}
      end
    end)
  end

  defp run_program_p2(
         instructions_list,
         accumulator_value,
         index_to_run,
         index_to_swap,
         visited_set
       ) do
    cond do
      MapSet.member?(visited_set, index_to_run) ->
        log("Reached an instruction previously visited: #{inspect({visited_set, index_to_run})}")
        {:loop, accumulator_value}

      index_to_run >= length(instructions_list) ->
        log(
          "Reached the end of the instructions: #{
            inspect({index_to_run, length(instructions_list)})
          }"
        )

        {:end, accumulator_value}

      true ->
        log("Running next instruction")
        visited_set = MapSet.put(visited_set, index_to_run)

        {{instruction, value}, _} =
          get_instruction_at_index(instructions_list, index_to_run, index_to_swap)

        case instruction do
          "nop" ->
            run_program_p2(
              instructions_list,
              accumulator_value,
              index_to_run + 1,
              index_to_swap,
              visited_set
            )

          "acc" ->
            run_program_p2(
              instructions_list,
              accumulator_value + value,
              index_to_run + 1,
              index_to_swap,
              visited_set
            )

          "jmp" ->
            run_program_p2(
              instructions_list,
              accumulator_value,
              index_to_run + value,
              index_to_swap,
              visited_set
            )
        end
    end
  end

  defp get_instruction_at_index(instructions_list, index_to_run, index_to_swap)
       when index_to_run == index_to_swap do
    log("Need to swap instructions at #{index_to_swap} | #{index_to_run}")

    case Enum.at(instructions_list, index_to_run) do
      {{"nop", value}, _} -> {{"jmp", value}, index_to_run}
      {{"jmp", value}, _} -> {{"nop", value}, index_to_run}
    end
  end

  defp get_instruction_at_index(instructions_list, index_to_run, _),
    do: Enum.at(instructions_list, index_to_run)
end
