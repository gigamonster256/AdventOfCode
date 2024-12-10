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
      """,
      multi_input: """
      ABC
      ABC
      ABC
      """,
      mapper_input: """
      123
      456
      789
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

  test "discard", %{input: input} do
    input = input |> parse()

    result = discard(input, [])
    assert result == input

    result = discard(input, "A")

    assert result ==
             {%{
                {1, 0} => "B",
                {2, 0} => "C",
                {0, 1} => "D",
                {1, 1} => "E",
                {2, 1} => "F",
                {0, 2} => "G",
                {1, 2} => "H",
                {2, 2} => "I"
              }, 3, 3}

    result = discard(input, ["A", "B", "C"])

    assert result ==
             {%{
                {0, 1} => "D",
                {1, 1} => "E",
                {2, 1} => "F",
                {0, 2} => "G",
                {1, 2} => "H",
                {2, 2} => "I"
              }, 3, 3}
  end

  test "multi_discard", %{multi_input: input} do
    input = input |> parse()

    result = discard(input, "A")

    assert result ==
             {%{
                {1, 0} => "B",
                {2, 0} => "C",
                {1, 1} => "B",
                {2, 1} => "C",
                {1, 2} => "B",
                {2, 2} => "C"
              }, 3, 3}

    result = discard(input, ["A", "B", "C"])

    assert result == {%{}, 3, 3}
  end

  test "replace/3", %{input: input} do
    input = input |> parse()

    result = replace(input, [], "X")
    assert result == input

    result = replace(input, ["A"], "X")

    assert result ==
             {%{
                {0, 0} => "X",
                {1, 0} => "B",
                {2, 0} => "C",
                {0, 1} => "D",
                {1, 1} => "E",
                {2, 1} => "F",
                {0, 2} => "G",
                {1, 2} => "H",
                {2, 2} => "I"
              }, 3, 3}

    result = replace(input, ["A", "B", "C"], "X")

    assert result ==
             {%{
                {0, 0} => "X",
                {1, 0} => "X",
                {2, 0} => "X",
                {0, 1} => "D",
                {1, 1} => "E",
                {2, 1} => "F",
                {0, 2} => "G",
                {1, 2} => "H",
                {2, 2} => "I"
              }, 3, 3}
  end

  test "multi_replace/3", %{multi_input: input} do
    input = input |> parse()

    result = replace(input, ["A"], "X")

    assert result ==
             {%{
                {0, 0} => "X",
                {1, 0} => "B",
                {2, 0} => "C",
                {0, 1} => "X",
                {1, 1} => "B",
                {2, 1} => "C",
                {0, 2} => "X",
                {1, 2} => "B",
                {2, 2} => "C"
              }, 3, 3}

    result = replace(input, ["A", "B", "C"], "X")

    assert result ==
             {%{
                {0, 0} => "X",
                {1, 0} => "X",
                {2, 0} => "X",
                {0, 1} => "X",
                {1, 1} => "X",
                {2, 1} => "X",
                {0, 2} => "X",
                {1, 2} => "X",
                {2, 2} => "X"
              }, 3, 3}
  end

  test "replace/2", %{input: input} do
    input = input |> parse()

    result = replace(input, %{"A" => "A"})
    assert result == input

    result = replace(input, %{"A" => "X"})

    assert result ==
             {%{
                {0, 0} => "X",
                {1, 0} => "B",
                {2, 0} => "C",
                {0, 1} => "D",
                {1, 1} => "E",
                {2, 1} => "F",
                {0, 2} => "G",
                {1, 2} => "H",
                {2, 2} => "I"
              }, 3, 3}

    result = replace(input, %{"A" => "X", "B" => "X", "C" => "X"})

    assert result ==
             {%{
                {0, 0} => "X",
                {1, 0} => "X",
                {2, 0} => "X",
                {0, 1} => "D",
                {1, 1} => "E",
                {2, 1} => "F",
                {0, 2} => "G",
                {1, 2} => "H",
                {2, 2} => "I"
              }, 3, 3}
  end

  test "multi_replace/2", %{multi_input: input} do
    input = input |> parse()

    result = replace(input, %{"A" => "X"})

    assert result ==
             {%{
                {0, 0} => "X",
                {1, 0} => "B",
                {2, 0} => "C",
                {0, 1} => "X",
                {1, 1} => "B",
                {2, 1} => "C",
                {0, 2} => "X",
                {1, 2} => "B",
                {2, 2} => "C"
              }, 3, 3}

    result = replace(input, %{"A" => "X", "B" => "X", "C" => "X"})

    assert result ==
             {%{
                {0, 0} => "X",
                {1, 0} => "X",
                {2, 0} => "X",
                {0, 1} => "X",
                {1, 1} => "X",
                {2, 1} => "X",
                {0, 2} => "X",
                {1, 2} => "X",
                {2, 2} => "X"
              }, 3, 3}
  end

  test "find", %{input: input} do
    input = input |> parse()

    result = find(input, "A")
    assert result == [{0, 0}]

    result = find(input, "B")
    assert result == [{1, 0}]

    result = find(input, "C")
    assert result == [{2, 0}]

    result = find(input, "D")
    assert result == [{0, 1}]

    result = find(input, "E")
    assert result == [{1, 1}]

    result = find(input, "F")
    assert result == [{2, 1}]

    result = find(input, "G")
    assert result == [{0, 2}]

    result = find(input, "H")
    assert result == [{1, 2}]

    result = find(input, "I")
    assert result == [{2, 2}]
  end

  test "multi_find", %{multi_input: input} do
    input = input |> parse()

    result = find(input, "A")
    assert result == [{0, 0}, {0, 1}, {0, 2}]

    result = find(input, "B")
    assert result == [{1, 0}, {1, 1}, {1, 2}]

    result = find(input, "C")
    assert result == [{2, 0}, {2, 1}, {2, 2}]
  end

  test "put", %{input: input} do
    input = input |> parse()

    result = put(input, {0, 0}, "X")

    assert result ==
             {%{
                {0, 0} => "X",
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

  test "uniq", %{input: input} do
    input = input |> parse()

    result = uniq(input)

    assert result == ["A", "D", "G", "B", "E", "H", "C", "F", "I"]
  end

  test "multi_uniq", %{multi_input: input} do
    input = input |> parse()

    result = uniq(input)

    assert result == ["A", "B", "C"]
  end

  defp mapper(char), do: String.to_integer(char)

  test "mapper", %{mapper_input: input} do
    result = parse(input, &mapper/1)

    assert result ==
             {%{
                {0, 0} => 1,
                {1, 0} => 2,
                {2, 0} => 3,
                {0, 1} => 4,
                {1, 1} => 5,
                {2, 1} => 6,
                {0, 2} => 7,
                {1, 2} => 8,
                {2, 2} => 9
              }, 3, 3}
  end
end
