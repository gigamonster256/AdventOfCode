defmodule AdventOfCode.Solution.Year2024.Day08 do
  use AdventOfCode.Solution.GridMap

  def part1(input) do
    input
    # all unique characters minus "." are the antennas
    |> uniq()
    |> Stream.reject(&(&1 == "."))
    # get the locations of each antenna type
    |> Stream.map(&find(input, &1))
    # get all permutations of antenna pairs
    |> Stream.flat_map(&antenna_set_permutations/1)
    # get the antinodes for each pair of antennas
    |> Stream.flat_map(&antinodes(input, &1))
    # only keep unique antinodes
    |> Stream.uniq()
    |> Enum.count()
  end

  def part2(input) do
    input
    |> uniq()
    |> Stream.reject(&(&1 == "."))
    |> Stream.map(&find(input, &1))
    |> Stream.flat_map(&antenna_set_permutations/1)
    |> Stream.flat_map(&all_antinodes(input, &1))
    |> Stream.uniq()
    |> Enum.count()
  end

  defp antenna_set_permutations(antenna_set) do
    {:ok, permutations} = Permutation.permute(antenna_set, cardinality: 2)

    permutations
  end

  defp antinodes(input, pair) do
    [pos1, pos2] = pair
    {x1, y1} = pos1
    {x2, y2} = pos2
    dx = x2 - x1
    dy = y2 - y1
    antinode1 = {x1 - dx, y1 - dy}
    antinode2 = {x2 + dx, y2 + dy}

    [antinode1, antinode2]
    |> Enum.filter(&is_valid_position?(input, &1))
  end

  defp all_antinodes(input, pair) do
    [pos1, pos2] = pair
    {x1, y1} = pos1
    {x2, y2} = pos2
    dx = x2 - x1
    dy = y2 - y1

    # subtract dx dy from pos1 until we are out of bounds
    back_antinodes =
      Stream.iterate(1, &(&1 + 1))
      |> Enum.reduce_while([pos1], fn steps, acc ->
        antinode = {x1 - steps * dx, y1 - steps * dy}

        if is_valid_position?(input, antinode),
          do: {:cont, [antinode | acc]},
          else: {:halt, acc}
      end)

    # add dx dy to pos2 until we are out of bounds
    forward_antinodes =
      Stream.iterate(1, &(&1 + 1))
      |> Enum.reduce_while([pos2], fn steps, acc ->
        antinode = {x2 + steps * dx, y2 + steps * dy}

        if is_valid_position?(input, antinode),
          do: {:cont, [antinode | acc]},
          else: {:halt, acc}
      end)

    back_antinodes ++ forward_antinodes
  end
end
