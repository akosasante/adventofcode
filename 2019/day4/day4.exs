Code.require_file("input_parser.exs", "../helpers")
Code.require_file("timed.exs", "../helpers")
defmodule Day4 do
  @input 245318..765747
  def input, do: @input
  
  defmodule Part1 do
    def run_brute() do
      Day4.input()
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
    
    def digits_increasing?(num) do
      digits = Integer.digits(num)
      Enum.sort(digits) == digits
    end
  end
  
  defmodule Part2 do
    def run_brute() do
      Day4.input()
      |> do_the_thing
      |> Enum.count
    end
    def do_the_thing(range) do
      Enum.filter(range, fn num ->
        num > 99_999 && has_only_one_double?(num) && Part1.digits_increasing?(num)
      end)
    end
    
    def has_only_one_double?(num) do
      valid_doubles = Integer.digits(num)
      |> Enum.chunk_while([], &doubles_chunker/2, &after_fun/1)
      |> Enum.filter(&(Enum.count(&1) == 2))
      |> Enum.count
#      IO.puts("num has #{valid_doubles} valid doubles")
      
      valid_doubles > 0
    end

    defp doubles_chunker(digit, []) do
#      IO.puts("chunk was empty, returning new chunk: #{inspect [digit]}")
      {:cont, [digit]}
    end
    defp doubles_chunker(digit, [prev_digit | _] = chunk_so_far) when digit == prev_digit do
#      IO.puts("prev_digit: #{prev_digit} matched #{digit}, adding to chunk so far: #{inspect [digit | chunk_so_far]}")
      {:cont, [digit | chunk_so_far]}
    end
    defp doubles_chunker(digit, chunk_so_far) do
#      IO.puts("chunk_so_far (#{inspect chunk_so_far}) didn't match digit (#{digit}), emitting chunk_so_far, and starting new chunk with digit")
      {:cont, chunk_so_far, [digit]}
    end

    defp after_fun([]), do: {:cont, []}
    defp after_fun(acc) do
#      IO.puts("FINISHED WITh EXTRA CHUNK: #{inspect acc}")
      {:cont, acc, []}
    end
  end
end

