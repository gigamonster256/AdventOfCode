defmodule AdventOfCode.Solution.Year2024.Day02 do
  use AdventOfCode.Solution.SharedParse

  @impl true
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def part1(parsed_input) do
    parsed_input
    |> Enum.map(&is_safe?/1)
    |> Enum.count(&(&1))
  end

  def part2(_parsed_input) do
  end

  defp process_pair(a, b) do
    cond do
      abs(a - b) > 3 -> :big_step
      a == b -> :equal
      a > b -> :decreasing
      a < b -> :increasing
    end
  end

  defp is_safe?(list, last \\ :begin)
  defp is_safe?([head, next | rest], last) do
    result = process_pair(head, next)
    cond do
      result == :big_step -> false
      result == :equal -> false
      last == :begin -> is_safe?([next | rest], result)
      result != last -> false
      true -> is_safe?([next | rest], result)
    end
  end
  defp is_safe?([_], _), do: true
  defp is_safe?([], _), do: true

end
