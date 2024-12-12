defmodule AdventOfCode.Solution.Year2024.Day12 do
  use AdventOfCode.Solution.GridMap

  def part1(input) do
    input
    |> uniq()
    |> Enum.map(&find(input, &1))
    |> Enum.flat_map(&regions/1)
    |> Enum.map(&price/1)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> uniq()
    |> Enum.map(&find(input, &1))
    |> Enum.flat_map(&regions/1)
    |> Enum.map(&new_price/1)
    |> Enum.sum()
  end

  @directions [:up, :down, :left, :right]

  @offsets %{
    up: {0, -1},
    down: {0, 1},
    left: {-1, 0},
    right: {1, 0}
  }

  defp neighbor_positions(pos) do
    {x, y} = pos

    @directions
    |> Enum.map(&Map.get(@offsets, &1))
    |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
  end

  defp regions(all_positions) do
    all_positions
    |> Stream.unfold(fn positions ->
      if Enum.empty?(positions),
        do: nil,
        else:
          (
            [start | positions] = positions
            {region, remaining} = greedy_region(start, positions)
            {region, remaining }
          )
    end)
    |> Enum.to_list()
  end

  defp greedy_region(pos, positions, region \\ MapSet.new()) do
    region = MapSet.put(region, pos)

    neighbor_positions(pos)
    |> Enum.filter(&Enum.member?(positions, &1))
    |> Enum.reduce({region, positions}, fn neighbor, {region, positions} ->
      if Enum.member?(positions, neighbor),
        do: greedy_region(neighbor, Enum.reject(positions, &(&1 == neighbor)), region),
        else: {region, positions}
    end)
  end

  defp price(region, part2 \\ false) do
    area(region) * if part2, do: perimiter_using_part2(region), else: perimiter(region)
  end

  defp area(region), do: MapSet.size(region)

  defp perimiter(region) do
    region
    |> Enum.reduce(0, fn pos, acc ->
      neighbors = neighbor_positions(pos)
      acc + (4 - Enum.count(neighbors, &MapSet.member?(region, &1)))
    end)
  end

  defp perimiter_using_part2(region) do
    region
    |> region_edges()
    |> Enum.count()
  end

  defp new_price(region) do
    area(region) * sides(region)
  end

  defp all_possible_edges(region) do
    region
    |> Enum.flat_map(fn pos ->
      @directions
      |> Enum.map(fn direction -> {pos, direction} end)
    end)
  end

  defp region_edges(region) do
    region
    |> all_possible_edges()
    |> annihilate_same_edges()
  end

  defp sides(region) do
    region
    |> region_edges()
    |> Stream.unfold(fn edges ->
      if Enum.empty?(edges),
        do: nil,
        else:
          (
            [edge | edges] = edges
            {_, edges} = greedy_side(edge, edges)
            {nil, edges}
          )
    end)
    |> Enum.count()
  end

  defp greedy_side(edge, other_edges, side \\ MapSet.new()) do
    side = MapSet.put(side, edge)

    edge_neighbors(edge)
    |> Enum.filter(&Enum.member?(other_edges, &1))
    |> Enum.reduce({side, other_edges}, fn neighbor, {side, other_edges} ->
      if Enum.member?(other_edges, neighbor),
        do: greedy_side(neighbor, Enum.reject(other_edges, &(&1 == neighbor)), side),
        else: {side, other_edges}
    end)
  end

  defp edge_neighbors({position, direction}) do
    {x, y} = position

    if direction in [:up, :down] do
      [
        {x - 1, y},
        {x + 1, y}
      ]
    else
      [
        {x, y - 1},
        {x, y + 1}
      ]
    end
    |> Enum.map(&{&1, direction})
  end

  @opposite_directions %{
    up: :down,
    down: :up,
    left: :right,
    right: :left
  }

  defp annihilate_same_edges(all_edges),
    do: annihilate_same_edges(all_edges, all_edges)

  defp annihilate_same_edges(edges, all_edges, acc \\ [])
  defp annihilate_same_edges([], _all_edges, acc), do: acc

  defp annihilate_same_edges([edge | rest], all_edges, acc) do
    corresponding_edge = corresponding_edge(edge)

    if Enum.member?(all_edges, corresponding_edge),
      do: annihilate_same_edges(rest, all_edges, acc),
      else: annihilate_same_edges(rest, all_edges, [edge | acc])
  end

  defp corresponding_edge({pos, direction}) do
    {x, y} = pos

    position =
      Map.get(@offsets, direction)
      |> then(fn {dx, dy} -> {x + dx, y + dy} end)

    {position, Map.get(@opposite_directions, direction)}
  end
end
