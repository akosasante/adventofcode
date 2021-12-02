defmodule Helpers.Shared do
  @cache_dir ".advent_inputs_cache"

  def calculate_year do
    today = Date.utc_today()

    if today.month < 12 do
      # It's before december so the newest advent calendar is not out yet, so use last year's by default
      today.year - 1
    else
      today.year
    end
  end

  def get_input(year, day) do
    IO.puts "Downloading input for #{year}/#{day}"
    AdventOfCodeHelper.get_input(year, day)
  end

  def get_file(year, day) do
    case get_filename(year, day) |> File.read() do
      {:ok, contents} -> {:ok, contents}
      {:error, _msg} -> {:fail, "No file found"}
    end
  end

  def get_filename(year, day) do
    Path.join(@cache_dir, "input_#{year}_#{day}")
  end

  def get_input_list_for_day(year, day, sep \\ "\n") do
    File.read!(get_filename(year, day))
    |> String.split(sep, trim: true)
  end

  def get_input_stream_for_day(year, day, sep \\ "\n") do
    File.stream!(get_filename(year, day))
    |> Stream.flat_map(&String.split(&1, sep, trim: true))
  end

  def log(message) do
    if System.get_env("PRINT_LOGS") == "true" do
      IO.puts(message)
    end
  end
end
