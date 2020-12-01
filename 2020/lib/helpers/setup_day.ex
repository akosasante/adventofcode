defmodule Mix.Tasks.SetupAdventDay do
  use Mix.Task

  @shortdoc "Download the input and create starter file(s) for given advent challenge of the day"

  @cache_dir ".advent_inputs_cache"

  def run([year, day, session]) do
    Finch.start_link(name: MyFinch)
    get_input(year, day, session)
  end

  def run([day, session]) do
    run([calculate_year(), day, session])
  end

  def get_input(year, day, session) do
    if in_cache?(year, day) do
      get_file(year, day)
    else
      save_input_from_site(year, day, session)
      get_file(year, day)
    end
  end

  def save_file(content, year, day) do
    unless @cache_dir |> File.exists? do
      File.mkdir(@cache_dir)
    end
    write_out("input_#{year}_#{day}", content)
    :ok
  end

  defp write_out(file, content) do
    Path.join(@cache_dir, file)
    |> File.write(content, [])
  end

  defp get_file(year, day) do
    case get_filename(year,day) |> File.read() do
      {:ok, contents} -> {:ok, contents}
      {:error, _msg} -> {:fail, "No file found"}
    end
  end

  defp in_cache?(year, day) do
    get_filename(year, day)
    |> File.exists?()
  end

  defp get_filename(year, day) do
    Path.join(@cache_dir, "input_#{year}_#{day}")
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

  defp generate_url(year,day) do
    "https://adventofcode.com/#{year}/day/#{day}/input"
  end

  defp generate_headers(session) do
    [{"cookie", "session=#{session}"}]
  end

  defp calculate_year do
    today = Date.utc_today
    if today.month < 12 do
      # It's before december so the newest advent calendar is not out yet, so use last year's by default
      today.year-1
    else
      today.year
    end
  end
end
