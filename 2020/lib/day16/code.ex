  defmodule Advent2020.Day16 do
    import Helpers.Shared, only: [log: 1]

    def part1(input) do
      log("Running 2020-16-P1-InputList")
      # parse rows
      # For each ticket, for each value, check if valid for _any_field. If no, return into list/stream, otherwise, continue
      # sum results
      {_, parsed_input} = parse_input(input)
      get_invalid_values(parsed_input.nearby_tickets_numbers, parsed_input.rules)
      |> Enum.sum()
    end

    def part1_optimized(input) do
      log("Running 2020-16-P1-InputListOptimized")
      "Not implemented"
    end

    def part1_stream(input_stream) do
      log("Running 2020-16-P1-InputStream")
      "Not implemented"
    end

    def part2(input) do
      log("Running 2020-16-P2-InputList")
      {_, parsed_input} = parse_input(input)
      filtered_nearby_tickets = reject_tickets_with_invalid_values(parsed_input.nearby_tickets_numbers, parsed_input.rules)
      match_columns_to_rules(filtered_nearby_tickets, parsed_input.rules)
      |> solve_p2(parsed_input.your_ticket_numbers)
    end

    def part2_optimized(input) do
      log("Running 2020-16-P2-InputListOptimized")
      "Not implemented"
    end

    def part2_stream(input_stream) do
      log("Running 2020-16-P2-InputStream")
      "Not implemented"
    end

    defp parse_input(input) do
      Enum.reduce(input, {:rules, %{}}, &parse_row/2)
    end

    defp parse_row("your ticket:", {_, parsed_map}), do: {:your_ticket, parsed_map}
    defp parse_row("nearby tickets:", {_, parsed_map}), do: {:nearby_tickets, parsed_map}

    defp parse_row(row, {:rules, parsed_map}) do
      existing_rules = Map.get(parsed_map, :rules, %{})
      pattern = ~r/^(.*): (\d+)-(\d+) or (\d+)-(\d+)$/
      [rule_name, min_rule1, max_rule1, min_rule2, max_rule2] = Regex.run(pattern, row, capture: :all_but_first)
      [min_rule1, max_rule1, min_rule2, max_rule2] = Enum.map([min_rule1, max_rule1, min_rule2, max_rule2], &String.to_integer/1)
      range1 = min_rule1..max_rule1
      range2 = min_rule2..max_rule2
      new_rules = Map.put(existing_rules, rule_name, [range1, range2])
      {:rules, Map.put(parsed_map, :rules, new_rules)}
    end

    defp parse_row(row, {:your_ticket, parsed_map}) do
      values = String.split(row, ",") |> Enum.map(&String.to_integer/1)
      {:your_ticket, Map.put(parsed_map, :your_ticket_numbers, values)}
    end

    defp parse_row(row, {:nearby_tickets, parsed_map}) do
      existing_nearby_tickets = Map.get(parsed_map, :nearby_tickets_numbers, [])
      values = String.split(row, ",") |> Enum.map(&String.to_integer/1)
      {:nearby_tickets, Map.put(parsed_map, :nearby_tickets_numbers, [values | existing_nearby_tickets])}
    end

    defp get_invalid_values(list_of_nearby_tickets_values, rules) do
      rule_ranges = Map.values(rules) |> List.flatten()
      Enum.flat_map(list_of_nearby_tickets_values, fn ticket ->
        Enum.reject(ticket, & is_valid_value?(&1, rule_ranges))
      end)
    end

    defp is_valid_value?(ticket_value, rule_ranges) do
      Enum.any?(rule_ranges, & is_valid_value_for_rule?(ticket_value, &1))
    end

    defp is_valid_value_for_rule?(ticket_value, rule_range), do: ticket_value in rule_range

    defp transpose_list_of_tickets(tickets), do: Enum.zip(tickets) |> Enum.map(&Tuple.to_list/1)

    defp is_column_valid_for_rule?(column, rule_ranges) do
      Enum.all?(column, & is_valid_value?(&1, rule_ranges))
    end

    defp reject_tickets_with_invalid_values(nearby_tickets, rules) do
      rule_ranges = Map.values(rules) |> List.flatten()
      Enum.filter(nearby_tickets, fn ticket -> Enum.all?(ticket, & is_valid_value?(&1, rule_ranges)) end)
    end

    defp match_columns_to_rules(nearby_tickets, rules) do
      columns = transpose_list_of_tickets(nearby_tickets)
      # for each column, find all the rules that are valid for it
      # for any columns that have only one valid rule, then that's the match, and remove that rule from all the other coluns
      # repeat

      map_of_columns_to_valid_rules = Enum.reduce(Enum.with_index(columns), %{}, fn {column, index}, map ->
        valid_rules = Enum.map(rules, fn {rule_name, rule_ranges} ->
          if is_column_valid_for_rule?(column, rule_ranges) do
#            log("column #{index} is valid for #{rule_name}")
            rule_name
          end
        end)
        |> Enum.reject(&is_nil/1)
        Map.put(map, index, valid_rules)
      end) |> IO.inspect

      Stream.unfold({%{}, map_of_columns_to_valid_rules}, fn {map_of_rule_to_column, map_of_cols_to_rules} ->
        cond do
          Enum.count(map_of_rule_to_column) == Enum.count(columns) ->
            log("map is same size as columns, our work should be done")
            nil
          true ->
            columns_with_one_valid_rule =
              map_of_cols_to_rules
             |> Enum.filter(fn {_, valid_rules} -> Enum.count(valid_rules) == 1 end)
             |> Enum.map(fn {index, [valid_rule]} -> {valid_rule, index} end)
             |> Map.new()
             |> IO.inspect(label: :map_of_cols_with_a_single_valid_rule)

           filtered_col_map =
             map_of_cols_to_rules
             |> Enum.map(fn {index, valid_rules} ->
               {index, Enum.reject(valid_rules, fn rule -> rule in Map.keys(columns_with_one_valid_rule) end)}
             end)
             |> Map.new()
             |> IO.inspect(label: :filtered_cols)

           new_map = Map.merge(columns_with_one_valid_rule, map_of_rule_to_column)
           {new_map, {new_map, filtered_col_map}}
        end
      end)
      |> Enum.to_list()
      |> List.last()
    end

    defp solve_p2(solved_rule_map, your_ticket, starting_word \\ "departure") do
      Enum.reduce(solved_rule_map, %{}, fn {rule_name, column_index}, acc ->
        your_ticket_value = Enum.at(your_ticket, column_index)
        Map.put(acc, rule_name, your_ticket_value)
      end)
      |> Enum.filter(fn {rule_name, _} -> String.starts_with?(rule_name, starting_word) end)
      |> Enum.reduce(1, fn {_, value}, acc -> acc * value end)
    end
  end
