defmodule InputParser do
  def read_input_text(file_path) do
    File.read!(file_path)
  end
  
  def input_body_to_list(body, sep \\ "\n", as_int \\ false) do
    body = body
    |> String.trim
    |> String.split(sep)
    case as_int do
      true -> Enum.map(body, &String.to_integer/1)
      false -> body
    end
  end
  
  def stream_input_text(file_path, split \\ nil, as_int \\ false) do
    stream = File.stream!(file_path) |> Stream.map(&String.trim/1)
    stream = case split do
      nil -> stream
      sep -> Stream.flat_map(stream, &(String.split(&1, sep)))
    end
    case as_int do
       true -> Stream.map(stream, &String.to_integer/1)
       false -> stream
    end
  end
  
  def get_path_for_day(day) do
    home_dir_2019 = "/Users/aasante/h-dev/advent_of_code/2019/"
    Path.join(home_dir_2019, "day#{day}")
    |> Path.join("/day#{day}input.txt")
  end
  
  def get_input_list_for_day(day, sep \\ "\n", as_int \\ false) do
    get_path_for_day(day)
    |> read_input_text
    |> input_body_to_list(sep, as_int)
  end
  
  def get_input_stream_for_day(day, sep \\ nil, as_int \\ false) do
    get_path_for_day(day)
    |> stream_input_text(sep, as_int)
  end
end
