defmodule AdventOfCode.Solution.Year2024.Day08Test do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.Year2024.Day08

  setup do
    [
      input: """
      ............
      ........0...
      .....0......
      .......0....
      ....0.......
      ......A.....
      ............
      ............
      ........A...
      .........A..
      ............
      ............
      """
    ]
  end

  test "part1", %{input: input} do
    result = input |> parse() |> part1()

    assert result == 14
  end

  @tag :skip
  test "part2", %{input: input} do
    result = input |> parse() |> part2()

    assert result == 34
  end
end
