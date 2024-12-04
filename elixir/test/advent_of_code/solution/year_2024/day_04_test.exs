defmodule AdventOfCode.Solution.Year2024.Day04Test do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.Year2024.Day04

  setup do
    [
      input1_simple: """
      ....XXMAS.
      .SAMXMS...
      ...S..A...
      ..A.A.MS.X
      XMASAMX.MM
      X.....XA.A
      S.S.S.S.SS
      .A.A.A.A.A
      ..M.M.M.MM
      .X.X.XMASX
      """,
      input2_simple: """
      .M.S......
      ..A..MSMS.
      .M.S.MAA..
      ..A.ASMSM.
      .M.S.M....
      ..........
      S.S.S.S.S.
      .A.A.A.A..
      M.M.M.M.M.
      ..........
      """,
      input_full: """
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

  test "part1_simple", %{input1_simple: input} do
    result = input |> parse() |> part1()

    assert result == 18
  end

  test "part1_full", %{input_full: input} do
    result = input |> parse() |> part1()

    assert result == 18
  end

  test "part2_simple", %{input2_simple: input} do
    result = input |> parse() |> part2()

    assert result == 9
  end

  test "part2_full", %{input_full: input} do
    result = input |> parse() |> part2()

    assert result == 9
  end
end
