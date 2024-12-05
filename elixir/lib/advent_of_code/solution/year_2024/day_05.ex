defmodule AdventOfCode.Solution.Year2024.Day05 do
  use AdventOfCode.Solution.SharedParse

  @impl true
  def parse(input) do
    [rules, pages] = String.split(input, "\n\n")

    rules =
      rules
      |> String.split("\n")
      |> Stream.map(&String.split(&1, "|"))
      |> Stream.map(fn [a, b] -> {String.to_integer(b), String.to_integer(a)} end)
      |> Enum.reduce(%{}, fn {a, b}, acc ->
        Map.update(acc, a, MapSet.new([b]), &MapSet.put(&1, b))
      end)

    pages =
      pages
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
      end)

    {rules, pages}
  end

  def part1(input) do
    {rules, pages} = input

    pages
    |> Stream.filter(&valid_row?(&1, rules))
    |> Stream.map(&middle_element/1)
    |> Enum.sum()
  end

  def part2(input) do
    {rules, pages} = input

    pages
    |> Stream.reject(&valid_row?(&1, rules))
    |> Stream.map(&sort_by(&1, rules))
    |> Stream.map(&middle_element/1)
    |> Enum.sum()
  end

  defp illegal_nums(rules, num) do
    Map.get(rules, num, MapSet.new())
  end

  defp valid_row?(row, rules, illegal_numbers \\ MapSet.new())

  defp valid_row?([], _rules, _illegal_numbers), do: true

  defp valid_row?(row, rules, illegal_numbers) do
    [head | tail] = row

    head not in illegal_numbers and
      (
        new_illegal_numbers = illegal_nums(rules, head)
        valid_row?(tail, rules, new_illegal_numbers)
      )
  end

  defp middle_element(list) do
    length = Enum.count(list)
    Enum.at(list, div(length, 2))
  end

  defp sort_by(row, rules) do
    Enum.sort_by(row, & &1, fn a, b ->
      # if b is in a's illegal numbers, b should come first
      # note: the problem does not menion transitivity
      # so we assume we are given a consistent set of rules
      # with the transitive associations already resolved
      if b in illegal_nums(rules, a), do: true, else: false
    end)
  end
end
