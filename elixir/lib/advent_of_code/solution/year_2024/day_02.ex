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
    |> Enum.count(& &1)
  end

  def part2(parsed_input) do
    parsed_input
    |> Enum.map(&is_safe_can_fail?/1)
    |> Enum.count(& &1)
  end

  defp process_pair(a, b) do
    cond do
      abs(a - b) > 3 -> :big_step
      a == b -> :equal
      a > b -> :decreasing
      a < b -> :increasing
    end
  end

  defp is_safe?(list) do
    case is_safe(list) do
      true -> true
      {false, _} -> false
    end
  end

  defp is_safe(list, index \\ 0, last \\ :begin)

  defp is_safe([head, next | rest], index, last)
       when last in [:begin, :increasing, :decreasing] do
    result = process_pair(head, next)

    cond do
      result in [:big_step, :equal] -> {false, index}
      last == :begin -> is_safe([next | rest], index + 1, result)
      result != last -> {false, index}
      true -> is_safe([next | rest], index + 1, result)
    end
  end

  defp is_safe([_], _index, _last), do: true

  defp is_safe_can_fail?(list, failures \\ 1)
  defp is_safe_can_fail?(list, 0), do: is_safe?(list)

  defp is_safe_can_fail?(list, failures) do
    case is_safe(list) do
      true ->
        true

      {false, index} ->
        (index - 1)..(index + 1)
        |> Stream.filter(&(&1 >= 0))
        |> Enum.any?(&is_safe_can_fail?(List.delete_at(list, &1), failures - 1))
    end
  end
end
