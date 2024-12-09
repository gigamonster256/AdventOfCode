defmodule AdventOfCode.Solution.Year2024.Day09Test do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.Year2024.Day09

  setup do
    [
      input: """
      2333133121414131402
      """
    ]
  end

  test "parse", %{input: input} do
    result = parse(input)

    assert result ==
             {[{2, 0}, {3, 1}, {1, 2}, {3, 3}, {2, 4}, {4, 5}, {4, 6}, {3, 7}, {4, 8}, {2, 9}],
              [3, 3, 3, 1, 1, 1, 1, 1, 0]}
  end

  test "part1", %{input: input} do
    result = input |> parse() |> part1()

    assert result == 1928
  end

  test "part2", %{input: input} do
    result = input |> parse() |> part2()

    assert result == 2858
  end
end
