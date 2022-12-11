defmodule Advent2022.Day6 do
  require Logger

  def part1(input) do
    Logger.info("Running 2022-6-P1-InputList")
    detect_packet(input, 4)
  end

  defp detect_packet(input, packet_size) do
    input
    |> Enum.with_index()
    |> Enum.chunk_every(packet_size, 1)
    |> Enum.find(fn chunk ->
      num_unique = chunk
                   |> Enum.map(fn {letter, _index} -> letter end)
                   |> MapSet.new()
                   |> Enum.count()
      num_unique == packet_size
    end)
    |> List.last()
    |> IO.inspect(label: :input_for_day, pretty: true)
    |> then(fn {letter, index} -> index + 1 end)
  end

  def part2(input) do
    Logger.info("Running 2022-6-P2-InputList")
    detect_packet(input, 14)
  end
end
