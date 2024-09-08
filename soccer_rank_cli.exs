defmodule SoccerRankCLI do
  def parse_args(args) do
    {opts, _, _} =
      OptionParser.parse(args,
        aliases: [f: :input_path, o: :output_path, t: :filetype],
        strict: [input_path: :string, output_path: :string, filetype: :string]
      )

    {opts[:input_path], opts[:output_path], opts[:filetype]}
  end

  def read_input(input) when input == nil,
    do: IO.read(:stdio, :all) |> String.split("\n", trim: true)

  def read_input(input), do: File.stream!(input) |> Stream.map(&String.trim/1)
end

{input_path, output_path, filetype} = SoccerRankCLI.parse_args(System.argv())

lines = SoccerRankCLI.read_input(input_path)

SoccerRank.invoke(lines, output_path, filetype)
