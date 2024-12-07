defmodule AdventOfCode.Solution.Year2024.Day07 do
  use AdventOfCode.Solution.SharedParse

  @impl true
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(row) do
    [total, components] =
      row
      |> String.split(": ")

    total =
      total
      |> String.to_integer()

    components =
      components
      |> String.split()
      |> Enum.map(&String.to_integer/1)

    {total, components}
  end

  def part1(input) do
    input
    |> Stream.filter(fn {total, components} -> can_result_in?(total, components) end)
    |> Stream.map(fn {total, _} -> total end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> Stream.filter(fn {total, components} -> can_result_in_with_concat?(total, components) end)
    |> Stream.map(fn {total, _} -> total end)
    |> Enum.sum()
  end

  defp can_result_in?(target, components, acc \\ nil)
  defp can_result_in?(target, [], acc), do: acc == target

  defp can_result_in?(target, components, nil) do
    args = [target, components, &can_result_in?/3]

    [&can_add_to?/3, &can_multiply_to?/3]
    |> Enum.any?(&apply(&1, args))
  end

  defp can_result_in?(target, components, acc) do
    args = [target, components, &can_result_in?/3, acc]

    [&can_add_to?/4, &can_multiply_to?/4]
    |> Enum.any?(&apply(&1, args))
  end

  defp can_result_in_with_concat?(target, components, acc \\ nil)
  defp can_result_in_with_concat?(target, [], acc), do: acc == target

  defp can_result_in_with_concat?(target, components, nil) do
    args = [target, components, &can_result_in_with_concat?/3]

    [&can_add_to?/3, &can_multiply_to?/3, &can_concat_to?/3]
    |> Enum.any?(&apply(&1, args))
  end

  defp can_result_in_with_concat?(target, components, acc) do
    args = [target, components, &can_result_in_with_concat?/3, acc]

    [&can_add_to?/4, &can_multiply_to?/4, &can_concat_to?/4]
    |> Enum.any?(&apply(&1, args))
  end

  defp can_add_to?(target, [head | tail], callback, acc \\ 0),
    do: callback.(target, tail, acc + head)

  defp can_multiply_to?(target, [head | tail], callback, acc \\ 1),
    do: callback.(target, tail, acc * head)

  defp can_concat_to?(target, [head | tail], callback, acc \\ 0) do
    acc = (Integer.digits(acc) ++ Integer.digits(head)) |> Integer.undigits()
    callback.(target, tail, acc)
  end
end
