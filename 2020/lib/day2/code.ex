defmodule Advent2020.Day2.PasswordRule do
  require Record
  Record.defrecord(:rule, min: nil, max: nil, character: nil)
end

defmodule Advent2020.Day2.PasswordRuleStruct do
  defstruct [:min, :max, :character]
end

defmodule Advent2020.Day2 do
  require Record
  import Advent2020.Day2.PasswordRule
  alias Advent2020.Day2.PasswordRuleStruct
  import Helpers.Shared, only: [log: 1]

  def part1(input) do
    log("Running 2020-2-P1-InputList")
    Enum.count(input, fn input -> check_password_line(input) end)
  end

  def part1_optimized(input) do
    log("Running 2020-2-P1-InputListOptimized")
    Enum.count(input, fn input -> check_password_line(input, true) end)
  end

  def part1_stream(input_stream) do
    log("Running 2020-2-P1-InputStream")
    "Not implemented"
  end

  def part2(input) do
    log("Running 2020-2-P2-InputList")
    Enum.count(input, fn string ->
      {password, rule} = format_password_line(string)
      password = String.graphemes(password)
      char1 = if Enum.at(password, rule(rule, :min) - 1) == rule(rule, :character), do: 1, else: 0
      char2 = if Enum.at(password, rule(rule, :max) - 1) == rule(rule, :character), do: 1, else: 0

      Bitwise.bxor(char1, char2) == 1
    end)
  end

  def part2_optimized(input) do
    log("Running 2020-2-P2-InputListOptimized")
    "Not implemented"
  end

  def part2_stream(input_stream) do
    log("Running 2020-2-P2-InputStream")
    "Not implemented"
  end



  defp check_password_line(string, use_struct? \\ false) do
    format_password_line(string, use_struct?)
    |> password_character_count()
    |> is_password_valid?()
  end

  #eg: 13-15 c: cqbhncccjsncqcc
  def format_password_line(string, use_struct? \\ false) do
    %{"character" => char, "max" => max, "min" => min, "password" => pass} =
      Regex.named_captures( ~r/^(?<min>\d+)-(?<max>\d+) (?<character>\w): (?<password>\w+)$/, string)

    rule =
      if use_struct? do
        %PasswordRuleStruct{max: String.to_integer(max), min: String.to_integer(min), character: char}
      else
        rule(max: String.to_integer(max), min: String.to_integer(min), character: char)
      end

    {pass, rule}
  end

  defp password_character_count({password, rule}) when Record.is_record(rule) do
    count =
      password
      |> String.graphemes()
      |> Enum.count(fn char -> rule(rule, :character) == char end)

    {count, rule}
  end

  defp password_character_count({password, %PasswordRuleStruct{character: character} = rule}) do
    count =
      password
      |> String.graphemes()
      |> Enum.count(fn char -> character == char end)

    {count, rule}
  end

  def is_password_valid?({count, rule}) when Record.is_record(rule) do
    rule(rule, :min) <= count and rule(rule, :max) >= count
  end

  def is_password_valid?({count, %PasswordRuleStruct{min: min, max: max}}) do
    min <= count and max >= count
  end
end
