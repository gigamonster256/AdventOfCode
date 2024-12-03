defmodule AdventOfCode.Solution.Year2024.Day03 do
  def part1(input) do
    do_mul(input)
  end

  def part2(input) do
    do_mul_with_disable(input)
  end

  defp do_mul(input, state \\ :not_in_mul, acc \\ 0) do
    {rest, state, acc} = mul(input, state, acc)

    case rest do
      <<>> -> acc
      _ -> do_mul(rest, state, acc)
    end
  end

  defp do_mul_with_disable(input, state \\ :not_in_mul, acc \\ 0) do
    {rest, state, acc} = mul_with_disable(input, state, acc)

    case rest do
      <<>> -> acc
      _ -> do_mul_with_disable(rest, state, acc)
    end
  end

  defguardp is_digit(c) when c in ?0..?9

  defp mul(input, state, acc) do
    case state do
      :not_in_mul ->
        case input do
          <<"mul(", rest::binary>> ->
            {rest, {:first_number, []}, acc}

          <<_::8, rest::binary>> ->
            {rest, :not_in_mul, acc}
        end

      {:first_number, first_number} ->
        case input do
          <<c::8, rest::binary>> when is_digit(c) ->
            {rest, {:first_number, [c | first_number]}, acc}

          <<",", rest::binary>> ->
            {rest, {:second_number, {first_number, []}}, acc}

          <<_::8, rest::binary>> ->
            {rest, :not_in_mul, acc}
        end

      {:second_number, {first_number, second_number}} ->
        case input do
          <<c::8, rest::binary>> when is_digit(c) ->
            {rest, {:second_number, {first_number, [c | second_number]}}, acc}

          <<")", rest::binary>> ->
            mul_result =
              for(
                n <- [first_number, second_number],
                do: n |> Enum.reverse() |> List.to_integer()
              )
              |> Enum.reduce(&Kernel.*/2)

            acc = acc + mul_result
            {rest, :not_in_mul, acc}

          <<_::8, rest::binary>> ->
            {rest, :not_in_mul, acc}
        end
    end
  end

  defp mul_with_disable(input, state, acc) do
    case state do
      :disabled ->
        case input do
          <<"do()", rest::binary>> ->
            mul(rest, :not_in_mul, acc)

          <<_::8, rest::binary>> ->
            {rest, state, acc}
        end

      _ ->
        case input do
          <<"don't()", rest::binary>> ->
            {rest, :disabled, acc}

          _ ->
            mul(input, state, acc)
        end
    end
  end
end
