defmodule SoccerRankTest do
  use ExUnit.Case
  doctest SoccerRank

  test "input: sample-input.txt, output: expected-output.txt" do
    {_, expected} = File.read("expected-output.txt")
    lines = File.stream!("sample-input.txt") |> Stream.map(&String.trim/1)

    output =
      lines
      |> SoccerRank.export_teams_with_point()
      |> SoccerRank.sort_team_and_assign_ranks(fn {a, point_a}, {b, point_b} ->
        if(point_a == point_b, do: a < b, else: point_a > point_b)
      end)
      |> SoccerRank.render_rank_table("txt")

    assert output == expected
  end
end
