defmodule AdventOfCode.Solution.GridMap do
  def parse(input, mapper \\ &default_mapper/1) do
    rows = input |> String.split("\n", trim: true)
    row_count = Enum.count(rows)
    col_count = rows |> List.first() |> String.length()

    map =
      rows
      |> Enum.with_index()
      |> Enum.flat_map(fn {row, y} ->
        row
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.map(fn {char, x} -> {{x, y}, mapper.(char)} end)
      end)
      |> Enum.into(%{})

    {map, row_count, col_count}
  end

  def default_mapper(char), do: char

  defmodule HelperFunctions do
    def get(input, pos) do
      {map, _row_count, _col_count} = input

      if is_valid_position?(input, pos),
        do: Map.get(map, pos),
        else: :out_of_bounds
    end

    def is_valid_position?(input, {x, y}) do
      {_, row_count, col_count} = input
      x >= 0 and x < col_count and y >= 0 and y < row_count
    end

    def char_at_pos_is?(input, pos, char) do
      get(input, pos) == char
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
      Stream.flat_map(-border_radius..border_radius, fn dy ->
        Enum.map(-border_radius..border_radius, fn dx -> {x + dx, y + dy} end)
      end)
      |> Stream.map(&get(input, &1))
      |> Enum.chunk_every(2 * border_radius + 1)
    end

    def reject(input, []), do: input

    def reject(input, [char | rest]) do
      input
      |> reject(char)
      |> reject(rest)
    end

    def reject(input, char) do
      replace(input, %{char => :rejected})
    end

    def replace(input, [], _replacement), do: input

    def replace(input, chars, replacement) when is_list(chars) do
      {map, row_count, col_count} = input

      map =
        Map.new(map, fn {pos, c} ->
          replacement = if Enum.member?(chars, c), do: replacement, else: c
          {pos, replacement}
        end)

      {map, row_count, col_count}
    end

    def replace(input, replacement_map) when replacement_map == %{}, do: input

    def replace(input, replacement_map) when is_map(replacement_map) do
      {map, row_count, col_count} = input

      map =
        Map.new(map, fn {pos, c} ->
          replacement = Map.get(replacement_map, c, c)
          {pos, replacement}
        end)

      {map, row_count, col_count}
    end

    def find(input, char) do
      {map, _row_count, _col_count} = input

      map
      |> Map.keys()
      |> Enum.filter(&char_at_pos_is?(input, &1, char))
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
      |> Map.values()
      |> Enum.uniq()
    end
  end

  defmacro __using__(_) do
    quote do
      use AdventOfCode.Solution.SharedParse

      defp mapper(char), do: AdventOfCode.Solution.GridMap.default_mapper(char)

      defoverridable mapper: 1

      @impl true
      def parse(input), do: AdventOfCode.Solution.GridMap.parse(input, &mapper/1)

      import AdventOfCode.Solution.GridMap.HelperFunctions
    end
  end
end
