defmodule Mix.Tasks.Advent.DownloadInput do
  use Mix.Task

  @shortdoc "Download the input for given advent challenge of the day"

  @cache_dir ".advent_inputs_cache"

  import Helpers.Shared

  def run([year, day, session]) do
    Finch.start_link(name: MyFinch)
    get_input(year, day, session)
  end

  def run([day, session]) do
    run([calculate_year(), day, session])
  end

  def get_input(year, day, session) do
    if in_cache?(year, day) do
      IO.puts("Grabbing day##{day}_#{year} from cache")
      get_file(year, day)
    else
      IO.puts("Grabbing day##{day}_#{year} from site")
      save_input_from_site(year, day, session)
      get_file(year, day)
    end
  end

  def save_file(content, year, day) do
    unless @cache_dir |> File.exists?() do
      File.mkdir(@cache_dir)
    end

    write_out("input_#{year}_#{day}", content)
    :ok
  end

  defp write_out(file, content) do
    Path.join(@cache_dir, file)
    |> File.write(content, [])
  end

  defp in_cache?(year, day) do
    get_filename(year, day)
    |> File.exists?()
  end

  defp save_input_from_site(year, day, session) do
    get_body(year, day, session)
    |> save_file(year, day)
  end

  defp get_body(year, day, session) do
    {:ok, %Finch.Response{body: body, status: 200}} =
      Finch.build(:get, generate_url(year, day), generate_headers(session))
      |> Finch.request(MyFinch)

    body
  end

  defp generate_url(year, day) do
    "https://adventofcode.com/#{year}/day/#{day}/input"
  end

  defp generate_headers(session) do
    [{"cookie", "session=#{session}"}]
  end
end
