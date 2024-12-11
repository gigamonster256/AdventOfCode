defmodule AdventOfCode.Solution.Year2024.Day11 do
  use AdventOfCode.Solution.SharedParse
  use Memoize

  def parse(input) do
    input
    |> String.trim()
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  def part1(input, times \\ 25) do
    0..(times - 1)
    |> Enum.reduce(input, fn _, acc ->
      Enum.flat_map(acc, &blink/1)
    end)
    |> Enum.count()
  end

  def part2(input, times \\ 75) do
    input
    |> Enum.map(&blink(&1, times))
    |> Enum.sum()
  end

  defp blink(0), do: [1]

  defp blink(number) do
    if has_even_number_of_digits?(number),
      do: split_in_half(number),
      else: [number * 2024]
  end

  defp has_even_number_of_digits?(number) do
    number
    |> Integer.digits()
    |> length()
    |> rem(2) == 0
  end

  defp split_in_half(number) do
    digits = Integer.digits(number)
    half_length = digits |> length() |> div(2)

    digits
    |> Enum.chunk_every(half_length)
    |> Enum.map(&Integer.undigits/1)
  end

  defmemo(blink(_number, 0), do: 1)
  defmemo(blink(0, times), do: blink(1, times - 1))

  defmemo blink(number, times) do
    if has_even_number_of_digits?(number),
      do:
        number
        |> split_in_half()
        |> Enum.map(&blink(&1, times - 1))
        |> Enum.sum(),
      else: blink(number * 2024, times - 1)
  end
end
