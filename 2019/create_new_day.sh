#!/usr/bin/fish

DAY="day$1"
DAY_CAPITALIZED="Day$1"
MODULE_TEXT="Code.require_file(\"input_parser.exs\", \"../helpers\")\n\
Code.require_file(\"timed.exs\", \"../helpers\")\n\
defmodule ${DAY_CAPITALIZED} do\n\t
  defmodule Part1 do\n\t\t
    def run_brute() do\n\t\t
    end\n\t\t
    def do_the_thing do\n\t\t
    end\n\t
  end\n
  defmodule Part2 do\n
    def run_brute() do\n
    end\n
    def do_the_thing do\n
    end\n
  end\n
end\n"

mkdir -p $DAY

cd $DAY

touch "${DAY}.exs"
touch "${DAY}input.txt"

echo $MODULE_TEXT > "${DAY}.exs"

git add .