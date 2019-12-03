defmodule Timed do
  def measure_time(func) do
    {time, res} = :timer.tc(func)
    IO.puts("Returned: #{res} in #{time / 1_000}ms")
  end
  
  def avg_time(func, times) do
    Enum.map(1..times, fn _ ->
      {time, _res} = :timer.tc(func)
      time
    end)
    |> IO.inspect
    |> Enum.sum
    |> IO.inspect
    |> Kernel./(times)
  end
end