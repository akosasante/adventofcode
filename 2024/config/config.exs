import Config

config :advent_of_code_helper,
  session: System.get_env("ADVENT_SESSION"),
  cache_dir: ".advent_inputs_cache/"
