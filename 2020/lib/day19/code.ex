  defmodule Advent2020.Day19 do
    import Helpers.Shared, only: [log: 1]

    def part1(input) do
      log("Running 2020-19-P1-InputList")
#      [rule_strings, message_list] = input
#      messages = String.split(message_list, "\n")
#      rules_map = parse_rule_strings(rule_strings)
#      rule_regex = compile_rule_regex_from_key("0", rules_map)
#
#      Enum.count(messages, fn message ->
#        Regex.match?(rule_regex, message)
#      end)
    end

    def part1_optimized(input) do
      log("Running 2020-19-P1-InputListOptimized")
      "Not implemented"
    end

    def part1_stream(input_stream) do
      log("Running 2020-19-P1-InputStream")
      "Not implemented"
    end

    def part2(input) do
      log("Running 2020-19-P2-InputList")
      [rule_strings, message_list] = input
      messages = String.split(message_list, "\n")
      rules_map = parse_rule_strings(rule_strings)
      rule_regex = compile_rule_regex_from_key("0", rules_map, "part2")
      |> IO.inspect(label: :final_regex)


      Enum.count(messages, fn message ->
        Regex.match?(rule_regex, message)
      end)
    end

    def part2_optimized(input) do
      log("Running 2020-19-P2-InputListOptimized")
      "Not implemented"
    end

    def part2_stream(input_stream) do
      log("Running 2020-19-P2-InputStream")
      "Not implemented"
    end

    defp parse_rule_strings(rule_strings) do
      rule_strings
      |> String.split("\n")
      |> Enum.reduce(%{}, &parse_rule_string/2)
    end

    defp parse_rule_string(rule_string, rule_map) do
      [rule_id, rules] = Regex.run(~r/^(\d+): (.*)$/, rule_string, capture: :all_but_first)
      rules =
        rules
        |> String.split(" | ", trim: true)
        |> Enum.map(fn ruleset ->
          ruleset
          |> String.split(" ")
          |> Enum.reduce({}, fn rule, tup -> Tuple.append(tup, rule) end)
        end)
      Map.put(rule_map, rule_id, rules)
    end

    defp compile_rule_regex_from_key(key, rules_map, part \\ "part1")
    defp compile_rule_regex_from_key(key, rules_map, part) do
      log("starting from #{key} and checking")
      regex = compile_rule_regex(key, rules_map, part)

      "^#{regex}$"
      |> Regex.compile!
    end

    defp compile_rule_regex([{"\"a\""}], _, _) do
      log("returning A")
      ["a"]
    end
    defp compile_rule_regex([{"\"b\""}], _, _) do
      log("returning B")
      ["b"]
    end

    defp compile_rule_regex(rules, rules_map, part) when is_list(rules) do
      log("checking list of rules #{inspect rules}")
      Enum.map(rules, fn rule -> compile_rule_regex(rule, rules_map, part) end)
      |> IO.inspect(label: :list_res)
      |> Enum.reduce("(", fn rule, rule_string -> "#{rule_string}#{rule}|" end) # build a regex string like AB|BA
      |> String.trim_trailing("|")
      |> Kernel.<>(")")
      |> IO.inspect(label: :rules)
    end


    defp compile_rule_regex(rules, rules_map, part) when is_tuple(rules) do
      log("checking tuple of rules #{inspect rules}")
      rules
      |> Tuple.to_list()
      |> Enum.map(fn rule -> compile_rule_regex(rule, rules_map, part) end)
      |> IO.inspect(label: :tuple_map)
      |> Enum.reduce("(", fn rule, rule_string -> "#{rule_string}#{rule}" end) # build a regex string like (A)(AB)
      |> Kernel.<>(")")
      |> IO.inspect(label: :tuple_result)
    end

    defp compile_rule_regex("8", rules_map, "part2") do
      # 8: 42 | 42 8
      log("checking rule 8")
      regex_for_42 = compile_rule_regex("42", rules_map, "part2")
#                     |> IO.inspect(label: :regex_42)
      "(#{regex_for_42})+" |> IO.inspect(label: :regex_8)
    end

    defp compile_rule_regex("11", rules_map, "part2") do
      # 11: 42 31 | 42 11 31
      log("checking rule 11")
      regex_for_42 = compile_rule_regex("42", rules_map, "part2")
#      IO.puts "length of 42: #{String.replace(regex_for_42,  ~r/[^\w]/, "") |> String.length}"
#                     |> IO.inspect(label: :regex_42)
      regex_for_31 = compile_rule_regex("31", rules_map, "part2")
#                     |> IO.inspect(label: :regex_31)
#      IO.puts "length of 31: #{String.replace(regex_for_31,  ~r/[^\w]/, "") |> String.length}"
# The following didn't work because it created a reg exp thaat was too large
#      repeated = Enum.map_join(
#        1..4,
#        "|",
#        fn n ->
#          "(?:#{regex_for_42}{#{n}}#{regex_for_31}{#{n}})"
#        end) |> IO.inspect(label: :regex_11)
#      "(#{repeated})"
# Stole the following from: https://github.com/omginbd/aoc2020/blob/master/lib/day19.ex. (?& ) will repeat the named pattern recursively!

      repeated_pattern_random_name = "regex11_#{:rand.uniform(1000) |> Integer.to_string()}" # give each occurence of this a random name
      "(?'#{repeated_pattern_random_name}'#{regex_for_42}(?&#{repeated_pattern_random_name})?#{regex_for_31})"
    end

    defp compile_rule_regex(rule, rules_map, part) do
      log("checking rule #{rule}")
      compile_rule_regex(Map.get(rules_map, rule), rules_map, part)
    end
  end
