defmodule AdventOfCode.Solution.Year2024.Day04Test do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.Year2024.Day04

  setup do
    [
      parse_input: """
      XM
      AS
      """,
      input: """
      MMMSXXMASM
      MSAMXMSMSA
      AMXSXMAAMM
      MSAMASMSMX
      XMASAMXAMM
      XXAMMXXAMA
      SMSMSASXSS
      SAXAMASAAA
      MAMMMXMMMM
      MXMXAXMASX
      """
    ]
  end

  test "parse", %{parse_input: input} do
    result = parse(input)

    assert result == {%{{0, 0} => "X", {1, 0} => "M", {0, 1} => "A", {1, 1} => "S"}, 2, 2}
  end

  test "part1", %{input: input} do
    result = input |> parse() |> part1()

    assert result == 18
  end

  test "part2", %{input: input} do
    result = input |> parse() |> part2()

    assert result == 9
  end
end
