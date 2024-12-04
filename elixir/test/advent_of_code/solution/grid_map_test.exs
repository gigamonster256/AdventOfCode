defmodule AdventOfCode.Solution.GridMapTest do
  use ExUnit.Case, async: true

  import AdventOfCode.Solution.GridMap
  import AdventOfCode.Solution.GridMap.HelperFunctions

  setup do
    [
      input: """
      ABC
      DEF
      GHI
      """
    ]
  end

  test "parse", %{input: input} do
    result = parse(input)

    assert result ==
             {%{
                {0, 0} => "A",
                {1, 0} => "B",
                {2, 0} => "C",
                {0, 1} => "D",
                {1, 1} => "E",
                {2, 1} => "F",
                {0, 2} => "G",
                {1, 2} => "H",
                {2, 2} => "I"
              }, 3, 3}
  end

  test "get", %{input: input} do
    result = input |> parse() |> get({1, 1})
    assert result == "E"

    result = input |> parse() |> get({0, 0})
    assert result == "A"

    result = input |> parse() |> get({2, 2})
    assert result == "I"
  end

  test "is_valid_position?", %{input: input} do
    input = input |> parse()

    assert is_valid_position?(input, {0, 0})
    assert is_valid_position?(input, {2, 2})
    assert !is_valid_position?(input, {-1, 0})
    assert !is_valid_position?(input, {0, -1})
    assert !is_valid_position?(input, {3, 0})
    assert !is_valid_position?(input, {0, 3})
  end

  test "all_positions", %{input: input} do
    input = input |> parse()

    result = all_positions(input)
    assert result == [{0, 0}, {1, 0}, {2, 0}, {0, 1}, {1, 1}, {2, 1}, {0, 2}, {1, 2}, {2, 2}]
  end

  test "get_row", %{input: input} do
    input = input |> parse()

    result = get_row(input, 0)
    assert result == ["A", "B", "C"]

    result = get_row(input, 1)
    assert result == ["D", "E", "F"]

    result = get_row(input, 2)
    assert result == ["G", "H", "I"]
  end

  test "get_col", %{input: input} do
    input = input |> parse()

    result = get_col(input, 0)
    assert result == ["A", "D", "G"]

    result = get_col(input, 1)
    assert result == ["B", "E", "H"]

    result = get_col(input, 2)
    assert result == ["C", "F", "I"]
  end

  test "get_square_around", %{input: input} do
    input = input |> parse()

    result = get_square_around(input, {0, 0}, 0)
    assert result == [["A"]]

    result = get_square_around(input, {1, 1}, 0)
    assert result == [["E"]]

    result = get_square_around(input, {0, 0}, 1)
    assert result == get_square_around(input, {0, 0})
    assert result == [[nil, nil, nil], [nil, "A", "B"], [nil, "D", "E"]]

    result = get_square_around(input, {1, 1}, 1)
    assert result == get_square_around(input, {1, 1})
    assert result == [["A", "B", "C"], ["D", "E", "F"], ["G", "H", "I"]]

    result = get_square_around(input, {1, 1}, 2)

    assert result == [
             [nil, nil, nil, nil, nil],
             [nil, "A", "B", "C", nil],
             [nil, "D", "E", "F", nil],
             [nil, "G", "H", "I", nil],
             [nil, nil, nil, nil, nil]
           ]

    result = get_square_around(input, {0, 0}, 2)

    assert result == [
             [nil, nil, nil, nil, nil],
             [nil, nil, nil, nil, nil],
             [nil, nil, "A", "B", "C"],
             [nil, nil, "D", "E", "F"],
             [nil, nil, "G", "H", "I"]
           ]
  end
end