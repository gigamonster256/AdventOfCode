defmodule AOC.Day2 do
  defp parse_draw(draw) do
    [number, color] = String.split(draw, " ")
    {String.to_integer(number), String.to_existing_atom(color)}
  end

  defp parse_set(set) do
    Enum.map(String.split(set, ", "), &parse_draw/1)
  end

  def parse_game(line) do
    [id, game] = String.split(line, ": ")
    id = id |> String.split(" ") |> List.last() |> String.to_integer()
    sets = String.split(game, "; ") |> Enum.map(&parse_set/1)
    {id, sets}
  end

  defp set_is_valid?(set, available_colors) do
    Enum.all?(set, fn {number, color} ->
      available_colors[color] >= number
    end)
  end

  def sets_are_valid?(sets, available_colors) do
    Enum.all?(sets, fn set ->
      set_is_valid?(set, available_colors)
    end)
  end

  defp smallest_to_cover_set(set, needed_colors) do
    Enum.reduce(set, needed_colors, fn {number, color}, acc ->
      Map.update!(acc, color, &max(&1, number))
    end)
  end

  def smallest_to_cover_sets(sets) do
    Enum.reduce(sets, %{red: 0, green: 0, blue: 0}, &smallest_to_cover_set/2)
  end

  def power(needed_colors) do
    Enum.product(Map.values(needed_colors))
  end
end

defmodule Main do
  import AOC.Day2

  IO.puts("Day 2")
  IO.write("Part 1: ")

  available_colors = %{
    red: 12,
    green: 13,
    blue: 14
  }

  File.stream!("day2.input", :line)
  |> Stream.map(&String.trim/1)
  |> Stream.map(&parse_game/1)
  |> Stream.filter(fn {_, sets} -> sets_are_valid?(sets, available_colors) end)
  |> Stream.map(&elem(&1, 0))
  |> Enum.sum()
  |> IO.inspect()

  IO.write("Part 2: ")

  File.stream!("day2.input", :line)
  |> Stream.map(&String.trim/1)
  |> Stream.map(&parse_game/1)
  |> Stream.map(&elem(&1, 1))
  |> Stream.map(&smallest_to_cover_sets/1)
  |> Stream.map(&power/1)
  |> Enum.sum()
  |> IO.inspect()
end
