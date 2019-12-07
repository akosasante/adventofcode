Code.require_file("input_parser.exs", "../helpers")
Code.require_file("timed.exs", "../helpers")
defmodule Day4 do
  defmodule Part1 do
    def run_brute() do
      input = 245318..765747
      input
      |> do_the_thing
      |> Enum.count
    end
    def do_the_thing(range) do
      Enum.filter(range, fn num ->
        num > 99_999 && has_a_double?(num) && digits_increasing?(num)
      end)
    end
    
    defp has_a_double?(num) do
      digits = Integer.digits(num)
      new_size = Enum.dedup(digits) |> Enum.count
      Enum.count(digits) != new_size
    end
    
    defp digits_increasing?(num) do
      digits = Integer.digits(num)
      Enum.sort(digits) == digits
    end
  end
  defmodule Part2 do
    def run_brute() do
    end
    def do_the_thing do
    end
  end
end

