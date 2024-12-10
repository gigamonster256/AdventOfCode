defmodule AdventOfCode.Solution.Year2024.Day10 do
  use AdventOfCode.Solution.GridMap

  # handle examples with . in the input
  defp mapper("."), do: :invalid
  defp mapper(char), do: String.to_integer(char)

  def part1(input) do
    trailheads(input)
    |> Enum.map(&score(input, &1))
    |> Enum.sum()
  end

  def part2(input) do
    trailheads(input)
    |> Enum.map(&rating(input, &1))
    |> Enum.sum()
  end

  @directions %{
    :up => {0, -1},
    :down => {0, 1},
    :right => {1, 0},
    :left => {-1, 0}
  }

  defp move({x, y}, {dx, dy}), do: {x + dx, y + dy}
  defp move({x, y}, dir) when is_atom(dir), do: move({x, y}, Map.get(@directions, dir))
  defp move_cardinal(pos), do: @directions |> Map.keys() |> Enum.map(&move(pos, &1))

  defp trailheads(input), do: find(input, 0)

  defp trailhead_endings(input, pos) do
    case get(input, pos) do
      9 ->
        [pos]

      current ->
        move_cardinal(pos)
        |> Enum.filter(&char_at_pos_is?(input, &1, current + 1))
        |> Enum.flat_map(&trailhead_endings(input, &1))
        |> Enum.uniq()
    end
  end

  defp score(input, pos) do
    trailhead_endings(input, pos)
    |> Enum.count()
  end

  defp rating(input, pos) do
    case get(input, pos) do
      9 ->
        1

      current ->
        move_cardinal(pos)
        |> Enum.filter(&char_at_pos_is?(input, &1, current + 1))
        |> Enum.map(&rating(input, &1))
        |> Enum.sum()
    end
  end
end
