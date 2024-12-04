defmodule AdventOfCode.Solution.Year2024.Day04 do
  use AdventOfCode.Solution.GridMap

  def part1(input) do
    all_positions(input)
    |> Enum.map(&count_xmas(input, &1))
    |> Enum.sum()
  end

  def part2(input) do
    all_positions(input)
    |> Enum.filter(&check_for_x_mas(input, &1))
    |> Enum.count()
  end

  @directions %{
    :north => {0, -1},
    :south => {0, 1},
    :west => {-1, 0},
    :east => {1, 0},
    :north_west => {-1, -1},
    :north_east => {1, -1},
    :south_west => {-1, 1},
    :south_east => {1, 1}
  }

  @nextchar %{
    nil => "X",
    "X" => "M",
    "M" => "A",
    "A" => "S"
  }

  defp count_xmas(input, position, last_char \\ nil, direction \\ nil)

  # if we find an S after an A, we have found an XMAS
  defp count_xmas(input, position, "A", _direction) do
    if char_at_pos_is?(input, position, "S"), do: 1, else: 0
  end

  defp count_xmas(input, postion, last_char, direction) do
    # next char in the nil -> X -> M -> A -> S sequence
    next_char = Map.get(@nextchar, last_char)

    if char_at_pos_is?(input, postion, next_char),
      do: count_xmas_in_direction(input, postion, next_char, direction),
      else: 0
  end

  # look in all directions
  defp count_xmas_in_direction(input, {x, y}, last_char, nil) do
    @directions
    |> Enum.map(fn {direction, {dx, dy}} -> {direction, {x + dx, y + dy}} end)
    |> Enum.map(fn {direction, pos} -> count_xmas(input, pos, last_char, direction) end)
    |> Enum.sum()
  end

  # continue in the same direction
  defp count_xmas_in_direction(input, {x, y}, last_char, direction) do
    {dx, dy} = Map.get(@directions, direction)
    next_position = {x + dx, y + dy}
    count_xmas(input, next_position, last_char, direction)
  end

  defp check_for_x_mas(input, a_position) do
    char_at_pos_is?(input, a_position, "A") and check_for_ms(input, a_position)
  end

  # M.S
  # .x.
  # M.S
  @ms_offsets %{
    {-1, -1} => "M",
    {-1, 1} => "M",
    {1, 1} => "S",
    {1, -1} => "S"
  }

  defp check_for_ms(input, {a_x, a_y}) do
    0..3
    |> Enum.map(&rotation(&1, @ms_offsets))
    |> Enum.any?(fn offsets ->
      offsets
      |> Enum.all?(fn {{dx, dy}, char} ->
        new_pos = {a_x + dx, a_y + dy}
        char_at_pos_is?(input, new_pos, char)
      end)
    end)
  end

  # rotate 90 degrees about the origin
  defp rotation(0, offsets), do: offsets

  defp rotation(num_rotations, offsets) when num_rotations >= 4,
    do: rotation(Integer.mod(num_rotations, 4), offsets)

  defp rotation(num_rotations, offsets) do
    new_offsets =
      Enum.reduce(offsets, %{}, fn {{x, y}, char}, acc ->
        Map.put(acc, {y, -x}, char)
      end)

    rotation(num_rotations - 1, new_offsets)
  end
end
