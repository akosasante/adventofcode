Code.require_file("input_parser.exs", "../helpers")
Code.require_file("timed.exs", "../helpers")
defmodule Day1 do
  defmodule Part1 do
    def run_brute() do
      # 70us (5000)
      input_list = InputParser.get_input_list_for_day(1)
      Enum.map(input_list, fn module_mass ->
        module_mass = String.to_integer(module_mass)
        quot = div(module_mass, 3)
        quot - 2
      end)
      |> Enum.sum
    end
    
    def run_stream() do
      # 247us (5000)
      InputParser.get_input_stream_for_day(1)
      |> Enum.map(&(&1 |> String.to_integer |> div(3) |> Kernel.-(2)))
      |> Enum.sum
    end
    
    def run_async_stream() do
      #789us (5000)
      InputParser.get_input_list_for_day(1)
      |> Task.async_stream(&(&1 |> String.to_integer |> div(3) |> Kernel.-(2)))
      |> Enum.reduce(0, fn {:ok, fuel_required}, acc -> acc + fuel_required end)
    end
  end
  
  defmodule Part2 do
    def get_fuel_needed_for_mod(mass) do
      fuel_required = mass
      |> div(3)
      |> Kernel.-(2)
    end
    def get_total_fuel_needed(:start, mass_of_module) do
      get_fuel_needed_for_mod(mass_of_module)
      |> get_total_fuel_needed
    end
    def get_total_fuel_needed(mass_of_module_or_fuel) do
      fuel_required = get_fuel_needed_for_mod(mass_of_module_or_fuel)
      if fuel_required < 0 do
        mass_of_module_or_fuel
      else
        mass_of_module_or_fuel + get_total_fuel_needed(fuel_required)
      end
    end
    
    def do_the_thing(thinger) do
      get_total_fuel_needed(:start, String.to_integer(thinger))
    end
    
    def run_brute() do
      # 95us (5000)
      InputParser.get_input_list_for_day(1)
      |> Enum.map(&(do_the_thing/1))
      |> Enum.sum
    end

    def run_stream() do
      # 274us (5000)
      InputParser.get_input_stream_for_day(1)
      |> Enum.map(&(do_the_thing/1))
      |> Enum.sum
    end

    def run_async_stream() do
      #865us (5000)
      InputParser.get_input_list_for_day(1)
      |> Task.async_stream(&(do_the_thing/1))
      |> Enum.reduce(0, fn {:ok, fuel_required}, acc -> acc + fuel_required end)
    end
  end
end