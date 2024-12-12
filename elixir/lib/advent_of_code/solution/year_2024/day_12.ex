defmodule AdventOfCode.Solution.Year2024.Day12 do
  use AdventOfCode.Solution.GridMap

  def part1(input) do
    input
    |> uniq_find()
    |> Map.values()
    |> Enum.flat_map(&regions/1)
    |> Enum.map(&price/1)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> uniq_find()
    |> Map.values()
    |> Enum.flat_map(&regions/1)
    |> Enum.map(&bulk_price/1)
    |> Enum.sum()
  end

  @directions [:up, :down, :left, :right]

  @offsets %{
    up: {0, -1},
    down: {0, 1},
    left: {-1, 0},
    right: {1, 0}
  }

  defp move({x, y}, {dx, dy}), do: {x + dx, y + dy}

  defp neighbor_positions(pos) do
    @offsets
    |> Map.values()
    |> Enum.map(&move(pos, &1))
  end

  defp regions(positions) do
    positions
    |> MapSet.new()
    |> Stream.unfold(&(Enum.take(&1, 1) |> region(&1)))
    |> Enum.to_list()
  end

  defp region(pos, positions, region \\ MapSet.new())
  defp region([], _positions, _region), do: nil
  defp region([pos], positions, region), do: region(pos, positions, region)

  defp region(pos, positions, region) do
    region = MapSet.put(region, pos)
    positions = MapSet.delete(positions, pos)

    neighbors =
      neighbor_positions(pos)
      |> Enum.filter(&MapSet.member?(positions, &1))

    positions =
      neighbors
      |> Enum.reduce(positions, fn neighbor, positions ->
        MapSet.delete(positions, neighbor)
      end)

    neighbors
    |> Enum.reduce({region, positions}, fn neighbor, {region, positions} ->
      region(neighbor, positions, region)
    end)
  end

  defp price(region) do
    area(region) * perimiter(region)
  end

  defp area(region), do: MapSet.size(region)

  defp perimiter(region) do
    region
    |> Enum.reduce(0, fn pos, acc ->
      neighbors_in_region = neighbor_positions(pos) |> Enum.count(&MapSet.member?(region, &1))
      acc + 4 - neighbors_in_region
    end)
  end

  defp bulk_price(region) do
    area(region) * count_sides(region)
  end

  defp edges(region) do
    region
    # find all positions that have a neighbor that is not in the region
    |> Enum.reject(fn pos ->
      neighbor_positions(pos)
      |> Enum.all?(&MapSet.member?(region, &1))
    end)
    # get the external edges of each position
    |> Enum.flat_map(&external_edges(region, &1))
    |> MapSet.new()
  end

  defp external_edges(region, pos) do
    @directions
    |> Enum.map(&{pos, &1})
    |> Enum.reject(fn {pos, side} ->
      pos = move(pos, @offsets[side])
      MapSet.member?(region, pos)
    end)
  end

  defp count_sides(region) do
    region
    |> edges()
    |> Stream.unfold(&(Enum.take(&1, 1) |> side(&1)))
    |> Enum.count()
  end

  defp side(edge, other_edges, side \\ MapSet.new())
  defp side([], _other_edges, _side), do: nil
  defp side([edge], other_edges, side), do: side(edge, other_edges, side)

  defp side(edge, other_edges, side) do
    side = MapSet.put(side, edge)
    other_edges = MapSet.delete(other_edges, edge)

    neighbors =
      edge_neighbors(edge)
      |> Enum.filter(&MapSet.member?(other_edges, &1))

    other_edges =
      neighbors
      |> Enum.reduce(other_edges, fn neighbor, other_edges ->
        MapSet.delete(other_edges, neighbor)
      end)

    neighbors
    |> Enum.reduce({side, other_edges}, fn neighbor, {side, other_edges} ->
      side(neighbor, other_edges, side)
    end)
  end

  defp edge_neighbors({pos, side}) do
    # neighbors of top and bottom edges are to the left and right
    # and vice versa
    if side in [:up, :down] do
      [
        @offsets[:left],
        @offsets[:right]
      ]
    else
      [
        @offsets[:up],
        @offsets[:down]
      ]
    end
    |> Enum.map(&move(pos, &1))
    |> Enum.map(&{&1, side})
  end
end
