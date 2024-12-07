defmodule AdventOfCode.Solution.Year2024.Day07 do
  use AdventOfCode.Solution.SharedParse

  @impl true
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_row/1)
  end

  defp parse_row(row) do
    [total, operands] = String.split(row, ": ")

    total = String.to_integer(total)

    operands =
      operands
      |> String.split()
      |> Enum.map(&String.to_integer/1)

    {total, operands}
  end

  def part1(input) do
    input
    |> Flow.from_enumerable()
    |> Flow.map(&Tuple.to_list/1)
    |> Flow.filter(fn args -> apply(&can_result_in?/2, args) end)
    |> Flow.map(&hd/1)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> Flow.from_enumerable()
    |> Flow.map(&Tuple.to_list/1)
    |> Flow.filter(fn args -> apply(&can_result_in_with_concat?/2, args) end)
    |> Flow.map(&hd/1)
    |> Enum.sum()
  end

  defp can_result_in?(target, operands, acc \\ 0)
  defp can_result_in?(target, [], acc), do: acc == target

  defp can_result_in?(target, operands, 0) do
    args = [target, operands, &can_result_in?/3]

    [&can_add_to?/3, &can_multiply_to?/3]
    |> Enum.any?(&apply(&1, args))
  end

  defp can_result_in?(target, operands, acc) do
    args = [target, operands, &can_result_in?/3, acc]

    [&can_add_to?/4, &can_multiply_to?/4]
    |> Enum.any?(&apply(&1, args))
  end

  defp can_result_in_with_concat?(target, operands, acc \\ 0)
  defp can_result_in_with_concat?(target, [], acc), do: acc == target

  defp can_result_in_with_concat?(target, operands, 0) do
    args = [target, operands, &can_result_in_with_concat?/3]

    [&can_add_to?/3, &can_multiply_to?/3, &can_concat_to?/3]
    |> Enum.any?(&apply(&1, args))
  end

  defp can_result_in_with_concat?(target, operands, acc) do
    args = [target, operands, &can_result_in_with_concat?/3, acc]

    [&can_add_to?/4, &can_multiply_to?/4, &can_concat_to?/4]
    |> Enum.any?(&apply(&1, args))
  end

  defp can_op_to?(target, [head | tail], callback, acc, op),
    do: callback.(target, tail, op.(acc, head))

  defp can_add_to?(target, operands, callback, acc \\ 0)
  defp can_add_to?(target, _, _callback, acc) when acc > target, do: false

  defp can_add_to?(target, operands, callback, acc),
    do: can_op_to?(target, operands, callback, acc, &Kernel.+/2)

  defp can_multiply_to?(target, operands, callback, acc \\ 1)
  defp can_multiply_to?(target, _, _callback, acc) when acc > target, do: false

  defp can_multiply_to?(target, operands, callback, acc),
    do: can_op_to?(target, operands, callback, acc, &Kernel.*/2)

  defp can_concat_to?(target, operands, callback, acc \\ 0)
  defp can_concat_to?(target, _, _callback, acc) when acc > target, do: false

  defp can_concat_to?(target, operands, callback, acc) do
    concat = &((Integer.digits(&1) ++ Integer.digits(&2)) |> Integer.undigits())
    can_op_to?(target, operands, callback, acc, concat)
  end
end
