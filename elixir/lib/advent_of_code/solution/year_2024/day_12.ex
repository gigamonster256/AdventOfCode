defmodule AdventOfCode.Solution.Year2024.Day12 do
  use AdventOfCode.Solution.GridMap

  def part1(input) do
    input
    |> uniq()
    |> Enum.flat_map(&regions(input, &1))
    |> Enum.map(&price/1)
    |> Enum.sum()
  end

  def part2(_input) do
  end

  @directions %{
    up: {0, -1},
    down: {0, 1},
    left: {-1, 0},
    right: {1, 0}
  }

  defp neighbor_positions(input, pos) do
    {x, y} = pos

    @directions
    |> Map.values()
    |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
    |> Enum.filter(&is_valid_position?(input, &1))
  end

  defp regions(input, char) do
    all_positions = find(input, char)

    Stream.unfold(all_positions, fn positions ->
      if Enum.empty?(positions),
        do: nil,
        else:
          (
            [start | positions] = positions
            {region, remaining} = greedy_region(input, start, MapSet.new(positions))
            {region, Enum.to_list(remaining)}
          )
    end)
    |> Enum.to_list()
    |> IO.inspect()
  end

  defp greedy_region(input, pos, positions, region \\ MapSet.new())

  defp greedy_region(input, pos, positions, region) do
    region = MapSet.put(region, pos)
    neighbors = neighbor_positions(input, pos)

    neighbors
    |> Enum.filter(&MapSet.member?(positions, &1))
    |> Enum.reduce({region, positions}, fn neighbor, {region, positions} ->
      if MapSet.member?(positions, neighbor),
        do: greedy_region(input, neighbor, MapSet.delete(positions, neighbor), region),
        else: {region, positions}
    end)
  end

  defp price(region) do
    area(region) * perimiter(region)
  end

  defp area(region), do: MapSet.size(region)

  defp perimiter(region) do
    # wut
    1
  end
end
