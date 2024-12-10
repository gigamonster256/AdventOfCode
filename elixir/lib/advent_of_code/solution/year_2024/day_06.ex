defmodule AdventOfCode.Solution.Year2024.Day06 do
  use AdventOfCode.Solution.GridMap

  @obstacle "#"
  @open "."

  def part1(input) do
    {pos, direction} = starting_position(input)

    path_taken(input, pos, direction)
    |> unique_positions()
    |> Enum.count()
  end

  def part2(input) do
    {pos, direction} = starting_position(input)

    path = path_taken(input, pos, direction)

    # brute force-ish
    input
    # open tiles on the path
    |> find(@open)
    |> Flow.from_enumerable()
    |> Flow.filter(&is_on_path?(path, &1))
    |> Flow.filter(
      # replace the path position with an obstacle
      &is_loop?(put(input, &1, @obstacle), pos, direction)
    )
    |> Enum.count()
  end

  @arrows %{"<" => :left, ">" => :right, "^" => :up, "v" => :down}

  defp starting_position(input) do
    @arrows
    |> Stream.flat_map(fn {arrow, direction} ->
      input
      |> find(arrow)
      |> Enum.map(fn pos ->
        {pos, direction}
      end)
    end)
    |> Enum.at(0)
  end

  @turn_right %{left: :up, up: :right, right: :down, down: :left}
  @directions %{
    :left => {-1, 0},
    :right => {1, 0},
    :up => {0, -1},
    :down => {0, 1}
  }

  defp move({x, y}, {dx, dy}), do: {x + dx, y + dy}
  defp move({x, y}, direction) when is_atom(direction) do
    move({x, y}, Map.get(@directions, direction))
  end

  defp path_taken(input, pos, direction, path \\ MapSet.new()) do
    path = MapSet.put(path, {pos, direction})

    next_pos = move(pos, direction)

    case get(input, next_pos) do
      :out_of_bounds -> path
      @obstacle -> path_taken(input, pos, @turn_right[direction], path)
      _ -> path_taken(input, next_pos, direction, path)
    end
  end

  defp unique_positions(path) do
    path
    |> Stream.map(&elem(&1, 0))
    |> Enum.uniq()
  end

  defp is_on_path?(path, {_pos, direction} = pos) when is_atom(direction) do
    MapSet.member?(path, pos)
  end

  defp is_on_path?(path, pos) do
    @directions
    |> Map.keys()
    |> Enum.any?(&is_on_path?(path, {pos, &1}))
  end

  defp is_loop?(input, pos, direction, path \\ MapSet.new()) do
    MapSet.member?(path, {pos, direction}) or
      (
        path = MapSet.put(path, {pos, direction})

        next_pos = move(pos, direction)

        case get(input, next_pos) do
          :out_of_bounds -> false
          @obstacle -> is_loop?(input, pos, @turn_right[direction], path)
          _ -> is_loop?(input, next_pos, direction, path)
        end
      )
  end
end
