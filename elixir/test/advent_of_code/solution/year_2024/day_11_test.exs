defmodule AdventOfCode.Solution.Year2024.Day11Test do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.Year2024.Day11

  setup do
    [
      input: """
      125 17
      """
    ]
  end

  test "parse", %{input: input} do
    result = parse(input)

    assert result == [125, 17]
  end

  test "part1 6", %{input: input} do
    result = input |> parse() |> part1(6)

    assert result == 22
  end

  test "part1 25", %{input: input} do
    result = input |> parse() |> part1()

    assert result == 55312
  end

  test "part2 25", %{input: input} do
    result = input |> parse() |> part2(25)

    assert result == 55312
  end

  test "part2 75", %{input: input} do
    result = input |> parse() |> part2()

    assert result == 65_601_038_650_482
  end
end
