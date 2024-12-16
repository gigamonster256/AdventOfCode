defmodule AdventOfCode.Solution.Year2024.Day15 do
  use AdventOfCode.Solution.SharedParse

  import AdventOfCode.Solution.GridMap.HelperFunctions

  @obstacle "#"
  @box "O"
  @robot "@"
  @empty "."

  @impl true
  def parse(input) do
    [grid, directions] =
      input
      |> String.split("\n\n", trim: true)

    map = AdventOfCode.Solution.GridMap.parse(grid)
    directions = directions |> String.replace("\n", "") |> String.graphemes()

    {map, directions}
  end

  def part1(input) do
    {map, directions} = input

    starting_pos = find(map, @robot) |> hd()

    map = put(map, starting_pos, ".")

    directions
    |> Enum.reduce({map, starting_pos}, fn direction, {map, pos} ->
      move(map, direction, pos)
    end)
    |> elem(0)
    |> gps_sum()
  end

  def part2(_input) do
  end

  @offsets %{
    "^" => {0, -1},
    "v" => {0, 1},
    "<" => {-1, 0},
    ">" => {1, 0}
  }

  defp move(map, direction, {x, y} = pos) do
    {dx, dy} = @offsets[direction]

    next_pos = {x + dx, y + dy}

    case get(map, next_pos) do
      # if the next position is an obstacle, do nothing
      @obstacle -> {map, pos}
      # if it's nothing, just move
      @empty -> {map, next_pos}
      # if it's a box, move the chain of boxes if we can
      @box -> move_boxes(map, direction, pos)
    end
  end

  defp move_boxes(map, direction, {x, y}) do
    in_front =
      case direction do
        "^" -> get_col(map, x) |> Enum.take(y - 1) |> Enum.reverse()
        "v" -> get_col(map, x) |> Enum.drop(y + 2)
        "<" -> get_row(map, y) |> Enum.take(x - 1) |> Enum.reverse()
        ">" -> get_row(map, y) |> Enum.drop(x + 2)
      end

    case first_open_spot(in_front) do
      nil ->
        {map, {x, y}}

      offset ->
        {dx, dy} = @offsets[direction]
        new_pos = {x + dx, y + dy}
        new_box_pos = {x + dx * offset, y + dy * offset}

        map =
          map
          |> put(new_pos, @empty)
          |> put(new_box_pos, @box)

        {map, new_pos}
    end
  end

  defp first_open_spot(boxes, offset \\ 2)
  defp first_open_spot([], _offset), do: nil

  defp first_open_spot([box | rest], offset) do
    case box do
      @obstacle -> nil
      @empty -> offset
      _ -> first_open_spot(rest, offset + 1)
    end
  end

  defp gps_sum(map) do
    all_positions(map)
    |> Enum.reduce(0, fn {x, y} = pos, acc ->
      case get(map, pos) do
        @box -> acc + x + y * 100
        _ -> acc
      end
    end)
  end
end
