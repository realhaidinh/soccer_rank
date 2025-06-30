defmodule SoccerRankTest do
  use ExUnit.Case
  doctest SoccerRankSerivce

  test "input: sample-input.txt, output: expected-output.txt" do
    {_, expected} = File.read("expected-output.txt")
    lines = File.stream!("sample-input.txt") |> Stream.map(&String.trim/1)

    output_path = "output.txt"
    SoccerRankSerivce.invoke(lines, output_path, :txt)
    {_, output} = File.read(output_path)
    assert output == expected
  end
end
