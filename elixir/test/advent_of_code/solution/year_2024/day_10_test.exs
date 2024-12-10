defmodule AdventOfCode.Solution.Year2024.Day10Test do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.Year2024.Day10

  setup do
    [
      input: """
      89010123
      78121874
      87430965
      96549874
      45678903
      32019012
      01329801
      10456732
      """,
      input2: """
      012345
      123456
      234567
      345678
      4.6789
      56789.
      """
    ]
  end

  test "part1", %{input: input} do
    result = input |> parse() |> part1()

    assert result == 36
  end

  test "part2", %{input: input} do
    result = input |> parse() |> part2()

    assert result == 81
  end

  test "part2 with input2", %{input2: input} do
    result = input |> parse() |> part2()

    assert result == 227
  end
end
