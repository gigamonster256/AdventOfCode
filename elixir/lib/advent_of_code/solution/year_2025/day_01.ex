defmodule AdventOfCode.Solution.Year2025.Day01 do
  use AdventOfCode.Solution.SharedParse

  @impl true
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      # split the first character and the rest of the string
      # then convert the rest to integer
      |> String.split_at(1)
      |> (fn {dir, rest} -> {dir, String.to_integer(rest)} end).()
    end)

    # |> transpose()
  end

  def part1(input) do
    input
    |> Enum.reduce({50, 0}, fn instruction, {pos, zero_count} ->
      newpos = rotate(instruction, pos)

      if newpos == 0 do
        {newpos, zero_count + 1}
      else
        {newpos, zero_count}
      end
    end)
    |> elem(1)
  end

  def part2(input) do
    input
    |> Enum.reduce({50, 0}, fn instruction, {pos, zero_count} ->
      {newpos, added_zeros} = rotate2(instruction, pos, 0)

      {newpos, zero_count + added_zeros}
    end)
    |> elem(1)
  end

  defp rotate({"R", amt}, pos) do
    rem(pos + amt, 100)
  end

  defp rotate({"L", amt}, pos) do
    rem(pos - amt, 100)
  end

  # pass 0
  defp rotate2({"R", amt}, pos, zero_cross)
       when amt > 100 do
    rotate2({"R", amt - 100}, pos, zero_cross + 1)
  end

  # end on 0
  defp rotate2({"R", amt}, pos, zero_cross)
       when pos + amt == 100 do
    {0, zero_cross + 1}
  end

  # pass 0 one last time
  defp rotate2({"R", amt}, pos, zero_cross)
       when pos + amt > 100 do
    {pos + amt - 100, zero_cross + 1}
  end

  # normal right rotation
  defp rotate2({"R", amt}, pos, zero_cross)
       when pos + amt < 100 do
    {amt + pos, zero_cross}
  end

  # pass 0
  defp rotate2({"L", amt}, pos, zero_cross)
       when amt > 100 do
    rotate2({"L", amt - 100}, pos, zero_cross + 1)
  end

  # end on 0
  defp rotate2({"L", amt}, pos, zero_cross)
       when pos - amt == 0 do
    {0, zero_cross + 1}
  end

  # normal left rotation
  defp rotate2({"L", amt}, pos, zero_cross)
       when pos - amt > 0 do
    {pos - amt, zero_cross}
  end

  # pass 0 one last time
  defp rotate2({"L", amt}, pos, zero_cross)
       when pos - amt < 0 and pos > 0 do
    {100 + (pos - amt), zero_cross + 1}
  end

  # rotate back from 0
  defp rotate2({"L", amt}, pos, zero_cross)
       when pos - amt < 0 and pos == 0 do
    {100 - amt, zero_cross}
  end
end
