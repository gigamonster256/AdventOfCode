defmodule AdventOfCode.Solution.Year2024.Day06 do
  use AdventOfCode.Solution.GridMap

  @obstacle "#"

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
    all_positions(input)
    # cant be the starting position
    |> Stream.reject(&(&1 == pos))
    # replacing an obstacle with an obstacle is not a loop
    |> Stream.reject(&char_at_pos_is?(input, &1, @obstacle))
    # must be on the original path
    |> Stream.filter(fn pos ->
      [:left, :right, :up, :down]
      |> Enum.any?(&is_on_path?(path, {pos, &1}))
    end)
    # check for loops
    |> Stream.filter(
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

  defp move({x, y}, :left), do: {x - 1, y}
  defp move({x, y}, :right), do: {x + 1, y}
  defp move({x, y}, :up), do: {x, y - 1}
  defp move({x, y}, :down), do: {x, y + 1}

  defp path_taken(input, pos, direction, path \\ MapSet.new()) do
    path = MapSet.put(path, {pos, direction})

    next_pos = move(pos, direction)

    case get(input, next_pos) do
      nil -> path
      @obstacle -> path_taken(input, pos, @turn_right[direction], path)
      _ -> path_taken(input, next_pos, direction, path)
    end
  end

  defp unique_positions(path) do
    path
    |> Stream.map(&elem(&1, 0))
    |> Enum.uniq()
  end

  defp is_on_path?(path, pos_with_direction) do
    MapSet.member?(path, pos_with_direction)
  end

  defp is_loop?(input, pos, direction, path \\ MapSet.new()) do
    MapSet.member?(path, {pos, direction}) or
      (
        path = MapSet.put(path, {pos, direction})

        next_pos = move(pos, direction)

        case get(input, next_pos) do
          nil -> false
          @obstacle -> is_loop?(input, pos, @turn_right[direction], path)
          _ -> is_loop?(input, next_pos, direction, path)
        end
      )
  end
end
