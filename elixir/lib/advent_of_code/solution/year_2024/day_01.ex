defmodule AdventOfCode.Solution.Year2024.Day01 do
  def part1(input) do
    # split the input into two lists then convert the elements to integers and sort
    [list1, list2] =
      for list <-
            input |> columns_to_lists(),
          do: list |> Enum.map(&String.to_integer/1) |> Enum.sort()

    # zip list and subtract the elements
    Enum.zip(list1, list2)
    |> Enum.map(fn {x, y} -> abs(x - y) end)
    |> Enum.sum()
  end

  def part2(input) do
    # split the input into two lists
    [list1, list2] =
      for list <-
            input |> columns_to_lists(),
          do: list |> Enum.map(&String.to_integer/1)

    # convert list 2 into a map of occurrences
    list2_map = count_occurrences(list2)
    # for each element in list 1, see how may times it occurred in list2 then multiply
    list1
    |> Enum.reduce(0, fn x, acc -> acc + Map.get(list2_map, x, 0) * x end)
  end

  defp columns_to_lists(text) do
    text
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> String.split(line, " ", trim: true) end)
    |> transpose()
  end

  # https://stackoverflow.com/questions/5389254/transposing-a-2-dimensional-matrix-in-erlang
  defp transpose([[] | _]) do
    []
  end

  defp transpose(matrix) do
    [Enum.map(matrix, &hd/1) | transpose(Enum.map(matrix, &tl/1))]
  end

  defp count_occurrences(list, acc \\ %{})
  defp count_occurrences([], acc), do: acc

  defp count_occurrences([head | tail], acc) do
    count_occurrences(tail, Map.update(acc, head, 1, &(&1 + 1)))
  end
end
