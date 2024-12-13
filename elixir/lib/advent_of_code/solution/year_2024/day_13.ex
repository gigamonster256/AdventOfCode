defmodule AdventOfCode.Solution.Year2024.Day13 do
  use AdventOfCode.Solution.SharedParse

  @impl true
  def parse(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_machine/1)
  end

  defp parse_machine(machine) do
    machine
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_line/1)
    |> List.to_tuple()
  end

  defp parse_line(line) do
    line
    |> String.split(": ")
    |> Enum.drop(1)
    |> then(&parse_coordinates/1)
  end

  defp parse_coordinates([coordinates]) do
    coordinates
    |> String.replace(~r/[XY=+]/, "")
    |> String.split(", ")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  def part1(input) do
    input
    |> Enum.map(&price/1)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> Enum.map(&part1_machine_to_part2_machine/1)
    |> part1()
  end

  defp part1_machine_to_part2_machine(machine) do
    {a, b, prize} = machine
    {px, py} = prize
    prize = {px + 10_000_000_000_000, py + 10_000_000_000_000}

    {a, b, prize}
  end

  defp presses({x1, y1}, {x2, y2}, {px, py}, button) do
    {numerator, denominator} =
      case button do
        :a -> {x2 * py - y2 * px, x2 * y1 - y2 * x1}
        :b -> {x1 * py - y1 * px, x1 * y2 - y1 * x2}
      end

    if rem(numerator, denominator) == 0,
      do: {:ok, div(numerator, denominator)},
      else: :error
  end

  defp price(machine) do
    {a, b, prize} = machine

    with {:ok, a_presses} <- presses(a, b, prize, :a),
         {:ok, b_presses} <- presses(a, b, prize, :b),
         do: 3 * a_presses + b_presses,
         else: (_ -> 0)
  end
end
