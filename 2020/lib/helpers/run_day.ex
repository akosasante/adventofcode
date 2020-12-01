defmodule Mix.Tasks.Advent.RunDay do
  use Mix.Task

  @shortdoc "Run the input for a given day's advent challenge"

  import Helpers.Shared

  def run(args) do
    year = get_year(args)
    day = get_day(args)
    bench = get_benchmark_flag(args)

    run_day(year, day, bench)
  end

  defp run_day(year, day, bench) do
    module_name = Module.concat("Advent#{year}", "Day#{day}")
    input = get_input_list_for_day(year, day)
    input_stream = get_input_stream_for_day(year, day)

    if bench do
      System.put_env("PRINT_LOGS", "false")

      Benchee.run(%{
        "Part 1" => fn -> apply(module_name, :part1, [input]) end,
        "Part 1 Stream" => fn -> apply(module_name, :part1_stream, [input_stream]) end,
        "Part 2" => fn -> apply(module_name, :part2, [input]) end,
        "Part 2 Stream" => fn -> apply(module_name, :part2_stream, [input_stream]) end
      }, print: %{benchmarking: false, configuration: false})
    else
      System.put_env("PRINT_LOGS", "true")

      p1_answer = apply(module_name, :part1, [input])
      p1s_answer = apply(module_name, :part1_stream, [input_stream])
      p2_answer = apply(module_name, :part2, [input])
      p2s_answer = apply(module_name, :part2_stream, [input_stream])

      IO.puts(
        """


        Day #{day}:
        ----------------------------
        Part 1:
        #{p1_answer}

        Part 1 Stream:
        #{p1s_answer}

        Part 2:
        #{p2_answer}

        Part 2 Stream:
        #{p2s_answer}
        ----------------------------
        """
      )
    end
  end

  defp get_year(args) do
    case Enum.find(args, &(String.starts_with?(&1, "year="))) do
      "year=" <> year -> year
      _ -> calculate_year()
    end
  end

  defp get_day(args) do
    case Enum.find(args, &(String.starts_with?(&1, "day="))) do
      "day=" <> day -> String.to_atom(day)
      _ -> raise "Must include day= argument"
    end
  end

  defp get_benchmark_flag(args) do
    case Enum.find(args, &(String.starts_with?(&1, "bench="))) do
      "bench=" <> bench when bench in ["false", "true"] -> String.to_atom(bench)
      nil -> false
      _ -> raise "If included, bench= argument can only have the values of `true` or `false`"
    end
  end
end
