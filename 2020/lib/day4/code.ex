defmodule Advent2020.Day4.Passport do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields_np_creds ~w(birth_year issue_year expiration_year height hair_colour eye_colour passport_id)a
  @optional_fields ~w(country_id)a
  @allowed_eye_colours ~w(amb blu brn gry grn hzl oth)

  schema "users" do
    field :birth_year, :integer
    field :issue_year, :integer
    field :expiration_year, :integer
    field :height, :string
    field :hair_colour, :string
    field :eye_colour, :string
    field :passport_id, :string
    field :country_id, :integer
  end

  def changeset(%{} = params \\ %{}, %__MODULE__{} = passport \\ %__MODULE__{}) do
    passport
    |> cast(params, @required_fields_np_creds ++ @optional_fields)
  end

  def validate_part1(changeset) do
    changeset
    |> validate_required(@required_fields_np_creds)
  end

  def validate_part2(changeset) do
    changeset
    |> validate_required(@required_fields_np_creds)
    |> validate_inclusion(:birth_year, 1920..2002)
    |> validate_inclusion(:issue_year, 2010..2020)
    |> validate_inclusion(:expiration_year, 2020..2030)
    |> validate_height()
    |> validate_hair_colour()
    |> validate_inclusion(:eye_colour, @allowed_eye_colours)
    |> validate_passport_id()
  end

  defp validate_height(changeset) do
    validate_change changeset, :height, fn :height, height ->
      case Regex.run(~r/^(\d+)(cm|in)$/, height, capture: :all_but_first) do
        [length, units] ->
          cond do
            units == "cm" and String.to_integer(length) in 150..193 -> []
            units == "in" and String.to_integer(length) in 59..76 -> []
            true -> [height: "height must be between 150-193cm or 59-76in"]
          end
        _ -> [height: "height must be a number followed by either cm or in"]
      end
    end
  end

  defp validate_hair_colour(changeset) do
    validate_change changeset, :hair_colour, fn :hair_colour, hair_colour ->
      if Regex.match?(~r/^#[0-9|a-f]{6}$/, hair_colour) do
        []
      else
        [hair_colour: "hair_colour must be a # followed by exactly six characters 0-9 or a-f"]
      end
    end
  end

  defp validate_passport_id(changeset) do
    validate_change changeset, :passport_id, fn :passport_id, passport_id ->
      if Regex.match?(~r/^\d{9}$/, passport_id) do
        []
      else
        [passport_id: "passport_id must be a nine-digit number, including leading zeroes"]
      end
    end
  end
end

defmodule Advent2020.Day4 do
    import Helpers.Shared, only: [log: 1]

    @required_fields_passport ~w(byr iyr eyr hgt hcl ecl pid cid)
    @required_fields_np_creds ~w(byr iyr eyr hgt hcl ecl pid)


    def part1(input) do
      log("Running 2020-4-P1-InputList")
      Enum.count(input, &is_valid_np_or_passport/1)
    end

    def part1_optimized(input) do
      log("Running 2020-4-P1-InputListOptimized")
      Enum.count(input, &is_valid_np_or_passport_changeset(&1, "part1"))
    end

    def part1_stream(input_stream) do
      log("Running 2020-4-P1-InputStream")
      "Not implemented"
    end

    def part2(input) do
      log("Running 2020-4-P2-InputList")
      Path.join(".advent_inputs_cache", "input_2020_4")
      |> File.read!()
      |> String.split("\n\n")
      |> Enum.map(&parse/1)
      |> Enum.count(fn cs ->
        IO.inspect(cs.valid?)
        cs.valid?
      end)
    end

    defp parse(entry) do
      parsed_map = entry
      |> String.split()
      |> Enum.map(&String.split(&1, ":"))
      |> Enum.map(fn [k, v] -> {String.to_atom(k), v} end)
      |> Map.new()

    %{
      birth_year: Map.get(parsed_map, :byr, nil),
      issue_year: Map.get(parsed_map, :iyr, nil),
      expiration_year: Map.get(parsed_map, :eyr),
      height: Map.get(parsed_map, :hgt),
      eye_colour: Map.get(parsed_map, :ecl),
      passport_id: Map.get(parsed_map, :pid),
      country_id: Map.get(parsed_map, :cid),
      hair_colour: Map.get(parsed_map, :hcl)
    }
    |> Advent2020.Day4.Passport.changeset()
    |> Advent2020.Day4.Passport.validate_part2()
    end

    def part2_optimized(input) do
      log("Running 2020-4-P2-InputListOptimized")
      Enum.count(input, &is_valid_np_or_passport_changeset(&1, "part2"))
    end

    def part2_stream(input_stream) do
      log("Running 2020-4-P2-InputStream")
      "Not implemented"
    end

    defp is_valid_np_or_passport(passport_to_check) do
      Enum.all?(@required_fields_np_creds, &String.contains?(passport_to_check, &1))
    end

    def is_valid_np_or_passport_changeset(passport_to_check, "part1") do
      cs = passport_to_check
      |> format_passport()
      |> Advent2020.Day4.Passport.changeset()
      |> Advent2020.Day4.Passport.validate_part1()

      cs.valid?
    end

    def is_valid_np_or_passport_changeset(passport_to_check, "part2") do
      cs = passport_to_check
           |> format_passport()
           |> Advent2020.Day4.Passport.changeset()
           |> Advent2020.Day4.Passport.validate_part2()

      if cs.valid?, do: IO.inspect({passport_to_check, cs})
      cs.valid?
    end

    def format_passport(passport_string) do
      field_map = %{
        "byr" => "birth_year",
        "iyr" => "issue_year",
        "eyr" => "expiration_year",
        "hgt" => "height",
        "hcl" => "hair_colour",
        "ecl" => "eye_colour",
        "pid" => "passport_id",
        "cid" => "country_id"
      }

      Enum.reduce(field_map, %{}, fn {field_key, struct_key}, param_map ->
        case Regex.run(~r/#{field_key}:([#]{0,1}\w+)(?>[\n| ]{1}|$)/, passport_string, capture: :all_but_first) do
          nil -> param_map
          [value] -> Map.put(param_map, struct_key, value)
        end
      end)
    end
  end
