defmodule Advent2022.Day2 do
  require Logger
  @opponent_rock "A"
  @opponent_paper "B"
  @opponent_scissors "C"
  @player_rock "X"
  @player_paper "Y"
  @player_scissors "Z"
  @player_must_lose "X"
  @player_must_draw "Y"
  @player_must_win "Z"

  def part1(input) do
    Logger.info("Running 2022-2-P1-InputList")

    input
    |> IO.inspect(label: :input_for_day1, pretty: true)
    |> Enum.map(&matchup_score/1)
    |> Enum.sum()
  end

  defp matchup_score(matchup) do
    shape_score(matchup) + outcome_score(matchup)
  end

  # rock gets 1 point
  defp shape_score(<<_opponent_choice::binary-size(1), " ", @player_rock>>), do: 1
  # paper gets 2 points
  defp shape_score(<<_opponent_choice::binary-size(1), " ", @player_paper>>), do: 2
  # scissors gets 3 points
  defp shape_score(<<_opponent_choice::binary-size(1), " ", @player_scissors>>), do: 3

  # draw
  defp outcome_score(<<@opponent_rock, " ", @player_rock>>), do: 3
  defp outcome_score(<<@opponent_paper, " ", @player_paper>>), do: 3
  defp outcome_score(<<@opponent_scissors, " ", @player_scissors>>), do: 3
  # wins (rock beats scissors, paper beats rock, scissors beats paper)
  defp outcome_score(<<@opponent_scissors, " ", @player_rock>>), do: 6
  defp outcome_score(<<@opponent_rock, " ", @player_paper>>), do: 6
  defp outcome_score(<<@opponent_paper, " ", @player_scissors>>), do: 6
  # loss (everything else)
  defp outcome_score(_matchup), do: 0

  def part2(input) do
    Logger.info("Running 2022-2-P2-InputList")

    input
    |> IO.inspect(label: :input_for_day2, pretty: true)
    |> Enum.map(&matchup_pt2_score/1)
    |> Enum.sum()
  end

  defp matchup_pt2_score(matchup) do
    <<opponent_shape::binary-size(1), " ", _player_outcome::binary-size(1)>> = matchup
    player_shape = determine_player_shape(matchup)
    matchup_score("#{opponent_shape} #{player_shape}")
  end

  defp determine_player_shape(<<@opponent_rock, " ", @player_must_lose>>), do: @player_scissors
  defp determine_player_shape(<<@opponent_paper, " ", @player_must_lose>>), do: @player_rock
  defp determine_player_shape(<<@opponent_scissors, " ", @player_must_lose>>), do: @player_paper

  defp determine_player_shape(<<@opponent_rock, " ", @player_must_draw>>), do: @player_rock
  defp determine_player_shape(<<@opponent_paper, " ", @player_must_draw>>), do: @player_paper
  defp determine_player_shape(<<@opponent_scissors, " ", @player_must_draw>>), do: @player_scissors

  defp determine_player_shape(<<@opponent_rock, " ", @player_must_win>>), do: @player_paper
  defp determine_player_shape(<<@opponent_paper, " ", @player_must_win>>), do: @player_scissors
  defp determine_player_shape(<<@opponent_scissors, " ", @player_must_win>>), do: @player_rock
end
