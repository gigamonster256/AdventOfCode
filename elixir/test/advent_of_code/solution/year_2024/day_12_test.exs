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
      """,
      input4: """
      EEEEE
      EXXXX
      EEEEE
      EXXXX
      EEEEE
      """,
      input5: """
      AAAAAA
      AAABBA
      AAABBA
      ABBAAA
      ABBAAA
      AAAAAA
      """
    ]
  end

  test "part1 input 1", %{input1: input} do
    result = input |> parse() |> part1()

    assert result == 140
  end

  test "part1 input 2", %{input2: input} do
    result = input |> parse() |> part1()

    assert result == 772
  end

  test "part1 input 3", %{input3: input} do
    result = input |> parse() |> part1()

    assert result == 1930
  end

  test "part2 input 1", %{input1: input} do
    result = input |> parse() |> part2()

    assert result == 80
  end

  test "part2 input 2", %{input2: input} do
    result = input |> parse() |> part2()

    assert result == 436
  end

  test "part2 input 3", %{input3: input} do
    result = input |> parse() |> part2()

    assert result == 1206
  end

  test "part2 input 4", %{input4: input} do
    result = input |> parse() |> part2()

    assert result == 236
  end

  test "part2 input 5", %{input5: input} do
    result = input |> parse() |> part2()

    assert result == 368
  end
end
