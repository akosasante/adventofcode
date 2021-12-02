defmodule Mix.Tasks.Advent.DownloadInput do
  use Mix.Task

  @shortdoc "Download the input for given advent challenge of the day"

  import Helpers.Shared

  def run([day]) do
    run([calculate_year(), day])
  end

  def run([year, day]) do
    AdventOfCodeHelper.get_input(year, day)
  end
end
