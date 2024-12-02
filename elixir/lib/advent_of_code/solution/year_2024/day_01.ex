defmodule AdventOfCode.Solution.Year2024.Day01 do
  use AdventOfCode.Solution.SharedParse

  # convert input text columns to list of lists
  @impl true
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
    |> transpose()
  end

  def part1(parsed_input) do
    # split the input into two lists then convert the elements to integers and sort
    parsed_input
    |> Enum.map(&Enum.sort/1)
    |> Enum.zip()
    |> Enum.map(fn {x, y} -> abs(x - y) end)
    |> Enum.sum()
  end

  def part2(parsed_input) do
    # split the input into two lists
    [list1, list2] = parsed_input

    # get frequencies of list2
    frequencies = Enum.frequencies(list2)

    list1
    |> Enum.map(&(&1 * Map.get(frequencies, &1, 0)))
    |> Enum.sum()
  end

  # https://stackoverflow.com/questions/5389254/transposing-a-2-dimensional-matrix-in-erlang
  defp transpose([[] | _]) do
    []
  end

  defp transpose(matrix) do
    [Enum.map(matrix, &hd/1) | transpose(Enum.map(matrix, &tl/1))]
  end
end
