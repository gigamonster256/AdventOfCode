defmodule AdventOfCode.Solution.Year2024.Day14 do
  use AdventOfCode.Solution.SharedParse

  @impl true
  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line) do
    line
    |> String.split(" ", trim: true)
    |> Enum.flat_map(&parse_pair/1)
    |> List.to_tuple()
  end

  defp parse_pair(pair) do
    pair
    |> String.replace(~r/[pv=]/, "")
    |> String.split(" ")
    |> Enum.map(&parse_nums/1)
  end

  defp parse_nums(num) do
    num
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def part1(input, bounds \\ {101, 103}) do
    input
    |> robots_after(bounds, 100)
    |> partition(bounds)
    |> Map.values()
    |> Enum.map(&Enum.count(&1))
    |> Enum.product()
  end

  # I assumed for part 2 that the chistmas tree would be in the center of the screen horizontally and have
  # left right symmetry. Looking at other people's solutions, I see that this is not the case.
  # but this code worked for me!
  def part2(input, bounds \\ {101, 103}, print \\ false) do
    Stream.iterate(0, &(&1 + 1))
    # get symmetrical differences for each second
    # (how different the left and right sides are)
    |> Stream.map(fn seconds ->
      input
      |> robots_after(bounds, seconds)
      |> partition(bounds)
      |> symmetric_difference(bounds)
    end)
    |> Stream.with_index()
    # assume it's in the first 10000 seconds
    |> Stream.take(10000)
    # find the minimum symmetric difference
    |> Enum.min_by(&elem(&1, 0))
    |> elem(1)
    |> tap(fn seconds ->
      if print do
        IO.puts("Seconds: #{seconds}")

        input
        |> robots_after(bounds, seconds)
        |> tap(&print_robots(&1, bounds))
        |> partition(bounds)
        |> symmetric_difference(bounds)
        |> IO.inspect(label: "Symmetric Difference")
      end
    end)
  end

  defp robots_after(input, bounds, seconds) do
    input
    |> Enum.map(&position_after(&1, bounds, seconds))
  end

  defp position_after({pos, vel}, bounds, seconds) do
    {x, y} = pos
    {vx, vy} = vel
    {bx, by} = bounds

    x = (((x + vx * seconds) |> rem(bx)) + bx) |> rem(bx)
    y = (((y + vy * seconds) |> rem(by)) + by) |> rem(by)
    {x, y}
  end

  defp partition(positions, bounds) do
    default = %{
      tl: [],
      tr: [],
      bl: [],
      br: []
    }

    Enum.reduce(positions, default, fn pos, acc ->
      case quadrant(pos, bounds) do
        :none -> acc
        quad -> Map.update!(acc, quad, &[pos | &1])
      end
    end)
  end

  defp quadrant({x, y}, bounds) do
    {bx, by} = bounds
    midx = div(bx - 1, 2)
    midy = div(by - 1, 2)

    cond do
      x < midx and y < midy -> :tl
      x > midx and y < midy -> :tr
      x < midx and y > midy -> :bl
      x > midx and y > midy -> :br
      true -> :none
    end
  end

  defp symmetric_difference(partitions, bounds) do
    tl = Map.fetch!(partitions, :tl) |> MapSet.new()
    tr = Map.fetch!(partitions, :tr)

    bl = Map.fetch!(partitions, :bl) |> MapSet.new()
    br = Map.fetch!(partitions, :br)

    reversed_tr = reverse_along_midy(tr, bounds) |> MapSet.new()
    reversed_br = reverse_along_midy(br, bounds) |> MapSet.new()

    top_diff = MapSet.difference(tl, reversed_tr) |> MapSet.size()
    bottom_diff = MapSet.difference(bl, reversed_br) |> MapSet.size()

    top_diff + bottom_diff
  end

  defp reverse_along_midy(partition, bounds) do
    {bx, _by} = bounds

    Enum.map(partition, fn {x, y} ->
      x = bx - x - 1
      {x, y}
    end)
  end

  defp print_robots(positions, bounds) do
    positions = MapSet.new(positions)
    {bx, by} = bounds

    0..(by - 1)
    |> Enum.map(fn y ->
      0..(bx - 1)
      |> Enum.map(fn x ->
        if MapSet.member?(positions, {x, y}) do
          "#"
        else
          "."
        end
      end)
      |> Enum.join()
    end)
    |> Enum.join("\n")
    |> then(&(&1 <> "\n"))
    |> IO.puts()
  end
end
