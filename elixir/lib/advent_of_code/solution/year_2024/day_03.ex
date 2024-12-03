defmodule AdventOfCode.Solution.Year2024.Day03 do
  def part1(input) do
    do_mul(input)
  end

  def part2(input) do
    do_mul_with_disable(input)
  end

  defp do_mul(input, state \\ :not_in_mul, acc \\ 0)
  defp do_mul(<<>>, _state, acc), do: acc

  defp do_mul(input, state, acc) do
    {rest, state, acc} = mul(input, state, acc)
    do_mul(rest, state, acc)
  end

  defp do_mul_with_disable(input, state \\ :not_in_mul, acc \\ 0)
  defp do_mul_with_disable(<<>>, _state, acc), do: acc

  defp do_mul_with_disable(input, state, acc) do
    {rest, state, acc} = mul_with_disable(input, state, acc)
    do_mul_with_disable(rest, state, acc)
  end

  defguardp is_digit(c) when c in ?0..?9

  defp mul(<<>>, state, acc), do: {<<>>, state, acc}

  defp mul(input, :not_in_mul, acc) do
    case input do
      # begin mul
      <<"mul(", rest::binary>> ->
        mul(rest, {:first_number, []}, acc)

      # skip char
      <<_::8, rest::binary>> ->
        {rest, :not_in_mul, acc}
    end
  end

  defp mul(input, {:first_number, first_number}, acc) do
    case input do
      # switch to second number
      <<",", rest::binary>> ->
        mul(rest, {:second_number, first_number, []}, acc)

      # accumulate first number
      <<c::8, rest::binary>> when is_digit(c) ->
        mul(rest, {:first_number, [c | first_number]}, acc)

      # fail to parse
      <<_::8, rest::binary>> ->
        {rest, :not_in_mul, acc}
    end
  end

  defp mul(input, {:second_number, first_number, second_number}, acc) do
    case input do
      # end mul
      <<")", rest::binary>> ->
        mul_result =
          for(
            n <- [first_number, second_number],
            do: n |> Enum.reverse() |> List.to_integer()
          )
          |> Enum.reduce(&Kernel.*/2)

        acc = acc + mul_result
        {rest, :not_in_mul, acc}

      # accumulate second number
      <<c::8, rest::binary>> when is_digit(c) ->
        mul(rest, {:second_number, first_number, [c | second_number]}, acc)

      # fail to parse
      <<_::8, rest::binary>> ->
        {rest, :not_in_mul, acc}
    end
  end

  defp mul_with_disable(<<>>, state, acc), do: {<<>>, state, acc}

  defp mul_with_disable(input, :disabled, acc) do
    case input do
      # enable
      <<"do()", rest::binary>> ->
        mul_with_disable(rest, :not_in_mul, acc)

      # skip char
      <<_::8, rest::binary>> ->
        mul_with_disable(rest, :disabled, acc)
    end
  end

  defp mul_with_disable(input, state, acc) do
    case input do
      # disable
      <<"don't()", rest::binary>> ->
        mul_with_disable(rest, :disabled, acc)

      # regular mul
      _ ->
        mul(input, state, acc)
    end
  end
end
