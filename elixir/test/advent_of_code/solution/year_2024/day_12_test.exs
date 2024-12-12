defmodule AdventOfCode.Solution.Year2024.Day12Test do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.Year2024.Day12

  setup do
    [
      input1: """
      AAAA
      BBCD
      BBCC
      EEEC
      """,
      input2: """
      OOOOO
      OXOXO
      OOOOO
      OXOXO
      OOOOO
      """,
      input3: """
      RRRRIICCFF
      RRRRIICCCF
      VVRRRCCFFF
      VVRCCCJFFF
      VVVVCJJCFE
      VVIVCCJJEE
      VVIIICJJEE
      MIIIIIJJEE
      MIIISIJEEE
      MMMISSJEEE
      """
    ]
  end

  @tag :skip
  test "part1 input 1", %{input1: input} do
    result = input |> parse() |> part1()

    assert result == 140
  end

  # @tag :skip
  test "part1 input 2", %{input2: input} do
    result = input |> parse() |> part1()

    assert result == 772
  end

  @tag :skip
  test "part1 input 3", %{input3: input} do
    result = input |> parse() |> part1()

    assert result == 1930
  end

  @tag :skip
  test "part2", %{input: input} do
    result = input |> parse() |> part2()

    assert result
  end
end
