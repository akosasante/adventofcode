defmodule Mix.Tasks.Advent.SetupDay do
  use Mix.Task

  @shortdoc "Create folder and starter file for given day's advent challenge"

  alias Helpers.Shared

  def run([year, day]) do
    IO.puts "Generating file(s) for Advent #{2020}, Day #{day}"
    file_path = Path.join(get_day_folder(day), "code.ex")

    File.write(
      file_path,
      skeleton_content(year, day)
    )
  end

  def run([day]) do
    run([Shared.calculate_year(), day])
  end

  defp get_day_folder(day) do
    path = "lib/day#{day}"
    unless File.exists?(path) do
      File.mkdir(path)
    end

    path
  end

  defp skeleton_content(year, day) do
    """
      defmodule Advent#{year}.Day#{day} do
        def part1(input) do
          IO.inspect(input)
        end

        def part1_stream(input_stream) do
          IO.inspect(input_stream)
        end

        def part2(input) do
          IO.inspect(input)
        end

        def part2_stream(input_stream) do
          IO.inspect(input_stream)
        end
      end
    """
  end
end
