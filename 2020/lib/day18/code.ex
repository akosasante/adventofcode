  defmodule Advent2020.Day18 do
    import Helpers.Shared, only: [log: 1]

    def part1(input) do
      log("Running 2020-18-P1-InputList")
      input
      |> Enum.map(&convert_to_postfix(&1, "part1"))
      |> Enum.map(&solve_postfix_expression/1)
      |> Enum.sum()
    end

    def part1_optimized(input) do
      log("Running 2020-18-P1-InputListOptimized")
      "Not implemented"
    end

    def part1_stream(input_stream) do
      log("Running 2020-18-P1-InputStream")
      input_stream
      |> Stream.map(&convert_to_postfix(&1, "part1"))
      |> Stream.map(&solve_postfix_expression/1)
      |> Enum.sum()
    end

    def part2(input) do
      log("Running 2020-18-P2-InputList")
      input
      |> Enum.map(&convert_to_postfix(&1, "part2"))
      |> Enum.map(&solve_postfix_expression/1)
      |> Enum.sum()
    end

    def part2_optimized(input) do
      log("Running 2020-18-P2-InputListOptimized")
      "Not implemented"
    end

    def part2_stream(input_stream) do
      log("Running 2020-18-P2-InputStream")
      input_stream
      |> Stream.map(&convert_to_postfix(&1, "part2"))
      |> Stream.map(&solve_postfix_expression/1)
      |> Enum.sum()
    end

    def convert_to_postfix(infix_string, part) do
      tokens = String.split(infix_string, ~r/\s|\B|\b/, trim: true)
      {output, remaining_operators} = Enum.reduce(tokens, {[], []}, fn token, {output_stack, operator_stack} ->
        log("=======================")
        log("Output stack: #{inspect output_stack}\nOperator stack: #{inspect operator_stack}")
        case Integer.parse(token) do
          {n, _} when is_number(n) ->
            log("push num onto output (#{n})")
            {[n | output_stack], operator_stack}
          :error -> case token do
            "(" ->
              log("push left paren onto operator stack")
              {output_stack, ["(" | operator_stack]}
            ")" -> find_matching_paren_and_update_stacks(output_stack, operator_stack)
            op ->
              log("processing operator (#{op})")
              process_operator_and_update_stacks(op, output_stack, operator_stack, part)
          end
        end
      end)

      output = if Enum.count(remaining_operators) > 0 do
        Enum.reverse(remaining_operators, output)
      else
        output
      end
      |> Enum.reverse()
    end

    defp find_matching_paren_and_update_stacks(output_stack, operator_stack) do
      log("processing right paren")
      {before_left_paren, after_left_paren} = Enum.split_while(operator_stack, fn op -> op != "(" end)
      {Enum.reverse(before_left_paren, output_stack), Enum.slice(after_left_paren, 1..-1)}
    end

    # 2 * 3 + (4 * 5)
    # PART1: 2 3 * 4 5 * +  [ (2*3) + (4*5) == (6) + (20) == 26 ]
    # PART2: 2 3 4 5 * + *  [ 2 * 3 + (4*5) == 2 * (3 + 20) == 2 * 23 == 46 ]

    def process_operator_and_update_stacks(operator, output_stack, operator_stack, "part1") do
      {before_left_paren, after_left_paren} = Enum.split_while(operator_stack, fn op -> op != "(" end)
      {Enum.reverse(before_left_paren, output_stack), [operator | after_left_paren]}
    end

    def process_operator_and_update_stacks(operator, output_stack, operator_stack, "part2") do
      {to_output, to_operator} = Enum.split_while(operator_stack, fn op_from_stack -> is_greater_precedence?(op_from_stack, operator) or operator == op_from_stack end)
      {Enum.reverse(to_output, output_stack), [operator | to_operator]}
    end

    defp is_greater_precedence?("+", "*"), do: true
    defp is_greater_precedence?(_, _), do: false


    def solve_postfix_expression(postfix_expression_as_list) do
      Enum.reduce(postfix_expression_as_list, [], fn token, stack ->
        log("Stack: #{inspect stack, charlists: :as_list}\nToken: #{token}")
        case token do
          n when is_number(n) -> [n | stack]
          op ->
            [first_num, second_num | rest] = stack
            res = apply(Kernel, String.to_atom(op), [first_num, second_num])
            [res | rest]
        end
      end)
      |> List.first()
    end
  end
