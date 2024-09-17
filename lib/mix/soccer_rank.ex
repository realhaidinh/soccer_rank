defmodule Mix.Tasks.SoccerRank do
  @moduledoc "Soccer Rank CLI application"

  use Mix.Task

  @impl Mix.Task
  def run(args) do
    {input_path, output_path, filetype} = parse_args(args)

    lines = read_input(input_path)

    SoccerRankSerivce.invoke(lines, output_path, filetype)
  end

  def parse_args(args) do
    {opts, _, _} =
      OptionParser.parse(args,
        aliases: [f: :input_path, o: :output_path, t: :filetype],
        strict: [input_path: :string, output_path: :string, filetype: :string]
      )

    {opts[:input_path], opts[:output_path], opts[:filetype]}
  end

  def read_input(input) when input == nil,
    do: IO.stream(:stdio, :line) |> Stream.flat_map(&String.split(&1,"\n", trim: true))

  def read_input(input), do: File.stream!(input) |> Stream.map(&String.trim/1)
end
