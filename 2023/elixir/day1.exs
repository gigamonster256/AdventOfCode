defmodule AOC.Day1 do
  def line_to_int(line) do
    integers =
      line
      |> String.graphemes()
      |> Enum.map(&Integer.parse/1)
      |> Enum.filter(&is_tuple/1)
      |> Enum.map(&elem(&1, 0))

    Integer.undigits([List.first(integers), List.last(integers)])
  end

  def line_to_part2_line(line) do
    line
    |> String.replace("one", "o1e")
    |> String.replace("two", "t2o")
    |> String.replace("three", "t3e")
    |> String.replace("four", "f4r")
    |> String.replace("five", "f5e")
    |> String.replace("six", "s6x")
    |> String.replace("seven", "s7n")
    |> String.replace("eight", "e8t")
    |> String.replace("nine", "n9e")
  end
end

defmodule Main do
  import AOC.Day1
  IO.puts("Day 1")
  IO.write("Part 1: ")

  File.stream!("day1.input", :line)
  |> Stream.map(&String.trim/1)
  |> Stream.map(&line_to_int/1)
  |> Enum.sum()
  |> IO.puts()

  IO.write("Part 2: ")

  File.stream!("day1.input", :line)
  |> Stream.map(&String.trim/1)
  |> Stream.map(&line_to_part2_line/1)
  |> Stream.map(&line_to_int/1)
  |> Enum.sum()
  |> IO.puts()
end
