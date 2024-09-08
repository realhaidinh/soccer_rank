defmodule SoccerRank do
  def invoke(lines, output_path, filetype) do
    point_list = SoccerRank.export_teams_with_point(lines)

    team_sorter = fn ({a, point_a}, {b, point_b}) ->
      if(point_a == point_b, do: a < b, else: point_a > point_b)
    end

    sorted_rank_list =
      SoccerRank.sort_team_and_assign_ranks(point_list, team_sorter)

    formatted_text = SoccerRank.render_rank_table(sorted_rank_list, "txt")
    IO.puts(formatted_text)

    if output_path != nil && filetype != nil do
      content =
        if(filetype == "txt",
          do: formatted_text,
          else: SoccerRank.render_rank_table(sorted_rank_list, "html")
        )

      File.write!(output_path, content)
    end
  end

  def export_teams_with_point(lines) do
    Enum.reduce(lines, %{}, fn line, result ->
      [_, team_a, score_a, team_b, score_b] =
        Regex.run(~r{^([\w\s]+)(\d+), ([\w\s]+)(\d+)$}, line)

      team_a = String.trim(team_a)
      team_b = String.trim(team_b)
      {point_a, point_b} = calculate_point(String.to_integer(score_a), String.to_integer(score_b))

      result
      |> Map.put(team_a, Map.get(result, team_a, 0) + point_a)
      |> Map.put(team_b, Map.get(result, team_b, 0) + point_b)
    end)
  end

  defp calculate_point(score_a, score_b) do
    cond do
      score_a > score_b -> {3, 0}
      score_a < score_b -> {0, 3}
      true -> {1, 1}
    end
  end

  def sort_team_and_assign_ranks(data, sorter) do
    data
    |> Enum.sort(sorter)
    |> Enum.with_index(1)
    |> Enum.map_reduce({1, -1}, fn {{cur_team, cur_point}, idx}, {prev_rank, prev_point} ->
      cur_rank = if cur_point == prev_point, do: prev_rank, else: idx
      {{cur_rank, cur_team, cur_point}, {cur_rank, cur_point}}
    end)
    |> elem(0)
  end

  def render_rank_table(rank_list, "html") do
    table = rank_list
    |> Enum.map(fn ({rank, team, point}) -> "<tr><td>#{rank}</td><td>#{team}</td><td>#{point}</td></tr>" end)
    |> Enum.join("\n")
    "<table>\n<tr><th>Rank</th><th>Team</th><th>Point</th></tr>\n#{table}\n</table>"
  end

  def render_rank_table(rank_list, "txt") do
    rank_list
    |> Enum.map(fn ({rank, team, point}) -> "#{rank}. #{team}, #{point} pt#{if(point != 1, do: "s", else: "")}" end)
    |> Enum.join("\n")
  end
end
