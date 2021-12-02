defmodule Mix.Tasks.Advent.SetupDay do
  use Mix.Task

  @shortdoc "Create folder and starter file for given day's advent challenge"

  import Helpers.Shared

  def run([year, day]) do
    Mix.Tasks.Advent.DownloadInput.run([year, day])

    IO.puts("Generating file(s) for Advent #{year}, Day #{day}")
    file_path = Path.join(get_day_folder(day), "code.ex")

    File.write(
      file_path,
      skeleton_content(year, day)
    )
  end

  def run([day]) do
    run([calculate_year(), day])
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
        import Helpers.Shared, only: [log: 1]

        def part1(input) do
          log("Running #{year}-#{day}-P1-InputList")
          "Not implemented"
        end

        def part1_optimized(input) do
          log("Running #{year}-#{day}-P1-InputListOptimized")
          "Not implemented"
        end

        def part1_stream(input_stream) do
          log("Running #{year}-#{day}-P1-InputStream")
          "Not implemented"
        end

        def part2(input) do
          log("Running #{year}-#{day}-P2-InputList")
          "Not implemented"
        end

        def part2_optimized(input) do
          log("Running #{year}-#{day}-P2-InputListOptimized")
          "Not implemented"
        end

        def part2_stream(input_stream) do
          log("Running #{year}-#{day}-P2-InputStream")
          "Not implemented"
        end
      end
    """
  end
end
