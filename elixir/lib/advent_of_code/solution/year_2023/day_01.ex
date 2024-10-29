defmodule AdventOfCode.Solution.Year2023.Day01 do
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&line_to_int/1)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&line_to_part2_line/1)
    |> Enum.map(&line_to_int/1)
    |> Enum.sum()
  end

  defp line_to_int(line) do
    integers =
      line
      |> String.graphemes()
      |> Enum.map(&Integer.parse/1)
      |> Enum.filter(&is_tuple/1)
      |> Enum.map(&elem(&1, 0))

    Integer.undigits([List.first(integers), List.last(integers)])
  end

  defp line_to_part2_line(line) do
    line
    |> String.replace("one", "o1e")
    |> String.replace("two", "t2o")
    |> String.replace("three", "t3e")
    |> String.replace("four", "f4r")
    |> String.replace("five", "f5e")
    |> String.replace("six", "s6x")
    |> String.replace("seven", "s7n")
    |> String.replace("eight", "e8t")
    |> String.replace("nine", "n9e")
  end
end
