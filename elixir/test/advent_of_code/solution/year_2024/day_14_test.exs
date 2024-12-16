defmodule AdventOfCode.Solution.Year2024.Day14Test do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.Year2024.Day14

  setup do
    [
      input: """
      p=0,4 v=3,-3
      p=6,3 v=-1,-3
      p=10,3 v=-1,2
      p=2,0 v=2,-1
      p=0,0 v=1,3
      p=3,0 v=-2,-2
      p=7,6 v=-1,-3
      p=3,0 v=-1,-2
      p=9,3 v=2,3
      p=7,3 v=-1,2
      p=2,4 v=2,-3
      p=9,5 v=-3,-3
      """
    ]
  end

  test "parse", %{input: input} do
    result = parse(input)

    assert result == [
             {{0, 4}, {3, -3}},
             {{6, 3}, {-1, -3}},
             {{10, 3}, {-1, 2}},
             {{2, 0}, {2, -1}},
             {{0, 0}, {1, 3}},
             {{3, 0}, {-2, -2}},
             {{7, 6}, {-1, -3}},
             {{3, 0}, {-1, -2}},
             {{9, 3}, {2, 3}},
             {{7, 3}, {-1, 2}},
             {{2, 4}, {2, -3}},
             {{9, 5}, {-3, -3}}
           ]
  end

  test "part1", %{input: input} do
    bounds = {11, 7}
    result = input |> parse() |> part1(bounds)

    assert result == 12
  end
end
