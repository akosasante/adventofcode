defmodule InputParser do
  def read_input_text(file_path) do
    File.read!(file_path)
  end
  
  def input_body_to_list(body, sep \\ "\n") do
    body
    |> String.trim
    |> String.split(sep)
  end
  
  def stream_input_text(file_path) do
    File.stream!(file_path)
  end
  
  def get_path_for_day(day) do
    home_dir_2019 = "/Users/aasante/h-dev/advent_of_code/2019/"
    Path.join(home_dir_2019, "day#{day}")
    |> Path.join("/day#{day}input.txt")
  end
  
  def get_input_list_for_day(day) do
    get_path_for_day(day)
    |> read_input_text
    |> input_body_to_list
  end
  
  def get_input_stream_for_day(day) do
    get_path_for_day(day)
    |> stream_input_text
    |> Stream.map(&String.trim/1)
  end
end