# Advent of Code Solutions

Elixir solutions for Advent of Code. Years: 2019 (plain scripts), 2020, 2021, 2022, 2024 (mix projects).

## Setup

1. Install the Elixir and Erlang versions in `.tool-versions` with asdf or mise. The root file covers 2020 to 2022. `2024/.tool-versions` pins newer versions.
2. In a year folder, run `mix deps.get`.
3. Get your puzzle session cookie. Sign in at [adventofcode.com](https://adventofcode.com), open browser devtools, and copy the value of the `session` cookie (Application or Storage tab, Cookies).
4. Export the cookie: `export ADVENT_SESSION=<value>`.
5. Run a day from the year folder: `mix advent.run_day day=<day> year=<year>`.

The cookie expires after a few weeks. Copy a new one if downloads fail with an auth error.

## Puzzle inputs

The [advent_of_code_helper](https://hex.pm/packages/advent_of_code_helper) package downloads each input on first run. It saves the input in `.advent_inputs_cache/` in the year folder. Git ignores this folder, because Advent of Code asks users not to publish inputs.

Other helper tasks: `mix advent.setup_day <year> <day>` creates a skeleton module for a new day. See the package docs for all options.

## Per-year notes

- 2019: scripts in `dayN/`. No mix project. Inputs are committed. `create_new_day.sh` needs fish.
- 2020: no `advent_of_code_helper`. The project has its own `advent.run_day`, `advent.setup_day`, and `advent.download_input` tasks in `lib/helpers/`. Run `mix advent.download_input <year> <day> <session>` and pass the cookie as an argument.
- 2021, 2022, 2024: `config/config.exs` reads `ADVENT_SESSION`. 2021 uses helper `~> 0.2.1` and its own tasks in `lib/tasks/`. 2022 uses `~> 0.3.1`. 2024 uses any version.
