defmodule AdventOfCode.Solution.GridMap do
  def parse(input) do
    rows = input |> String.split("\n", trim: true)
    row_count = Enum.count(rows)
    col_count = rows |> List.first() |> String.length()

    map =
      rows
      |> Enum.with_index()
      |> Enum.map(fn {row, y} ->
        row
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.map(fn {char, x} -> {{x, y}, char} end)
      end)
      |> List.flatten()
      |> Enum.into(%{})

    {map, row_count, col_count}
  end

  defmodule HelperFunctions do
    def get(input, pos) do
      {map, _row_count, _col_count} = input
      Map.get(map, pos)
    end

    def is_valid_position?(input, {x, y}) do
      {_, row_count, col_count} = input
      x >= 0 and x < col_count and y >= 0 and y < row_count
    end

    def char_at_pos_is?(input, pos, char) do
      is_valid_position?(input, pos) and get(input, pos) == char
    end

    def all_positions(input) do
      {_map, row_count, col_count} = input

      0..(row_count - 1)
      |> Enum.flat_map(fn y ->
        0..(col_count - 1)
        |> Enum.map(fn x -> {x, y} end)
      end)
    end

    def get_row(input, y) do
      {_map, _row_count, col_count} = input

      0..(col_count - 1)
      |> Enum.map(fn x -> get(input, {x, y}) end)
    end

    def get_col(input, x) do
      {_map, row_count, _col_count} = input

      0..(row_count - 1)
      |> Enum.map(fn y -> get(input, {x, y}) end)
    end

    def get_square_around(input, {x, y}, border_radius \\ 1) do
      Enum.flat_map(-border_radius..border_radius, fn dy ->
        Enum.map(-border_radius..border_radius, fn dx -> {x + dx, y + dy} end)
      end)
      |> Enum.map(fn pos -> get(input, pos) end)
      |> Enum.chunk_every(2 * border_radius + 1)
    end

    def discard(input, []), do: input

    def discard(input, [char | rest]) do
      input
      |> discard(char)
      |> discard(rest)
    end

    def discard(input, char) do
      {map, row_count, col_count} = input

      map =
        map
        |> Enum.reduce(%{}, fn {pos, c}, acc ->
          if c == char, do: acc, else: Map.put(acc, pos, c)
        end)

      {map, row_count, col_count}
    end

    def replace(input, [], _replacement), do: input

    def replace(input, chars, replacement) when is_list(chars) do
      {map, row_count, col_count} = input

      map =
        map
        |> Enum.reduce(%{}, fn {pos, c}, acc ->
          if Enum.member?(chars, c),
            do: Map.put(acc, pos, replacement),
            else: Map.put(acc, pos, c)
        end)

      {map, row_count, col_count}
    end

    def replace(input, replacement_map) when replacement_map == %{}, do: input

    def replace(input, replacement_map) when is_map(replacement_map) do
      {map, row_count, col_count} = input

      map =
        map
        |> Enum.reduce(%{}, fn {pos, c}, acc ->
          replacement = Map.get(replacement_map, c, c)
          Map.put(acc, pos, replacement)
        end)

      {map, row_count, col_count}
    end

    def find(input, char) do
      {map, _row_count, _col_count} = input

      map
      |> Enum.filter(fn {_, c} -> c == char end)
      |> Enum.map(fn {pos, _} -> pos end)
    end

    def put(input, pos, char) do
      {map, row_count, col_count} = input

      map = Map.put(map, pos, char)

      {map, row_count, col_count}
    end

    # get unique elements in a grid map
    def uniq(input) do
      {map, _row_count, _col_count} = input

      map
      |> Enum.map(fn {_, c} -> c end)
      |> Enum.uniq()
    end
  end

  defmacro __using__(_) do
    quote do
      use AdventOfCode.Solution.SharedParse

      @impl true
      def parse(input), do: AdventOfCode.Solution.GridMap.parse(input)

      import AdventOfCode.Solution.GridMap.HelperFunctions
    end
  end
end
