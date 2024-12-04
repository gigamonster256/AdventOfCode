defmodule AdventOfCode.Solution.Year2024.Day03Parser do
  import NimbleParsec

  def part1(input) do
    {:ok, [result], "", _, _, _} =
      input
      |> part1_parse()

    result
  end

  def part2(input) do
    {:ok, [result], "", _, _, _} =
      ("do()" <> input)
      |> mul_parse_enable()

    result
  end

  mul = string("mul")

  mul_block =
    ignore(mul)
    |> ignore(string("("))
    |> integer(min: 1, max: 3)
    |> ignore(string(","))
    |> integer(min: 1, max: 3)
    |> ignore(string(")"))
    |> wrap()
    |> map({Enum, :product, []})

  any_char = ascii_string([0..255], 1)

  greedy_mul_stream =
    choice([mul_block, ignore(any_char)]) |> repeat() |> wrap() |> map({Enum, :sum, []})

  do_ = string("do()")
  dont = string("don't()")

  terminated_mul_stream = fn terminator_comb ->
    empty()
    |> repeat_while(
      choice([mul_block, ignore(any_char)]),
      {:terminate?, [terminator_comb]}
    )
  end

  # this seems really expensive and hacky
  defp terminate?(rest, context, _line, _offset, terminator_comb) do
    case apply(__MODULE__, terminator_comb, [rest]) do
      {:ok, _, _, _, _, _} -> {:halt, context}
      _ -> {:cont, context}
    end
  end

  do_block = ignore(do_) |> concat(terminated_mul_stream.(:dont))
  dont_block = ignore(dont) |> concat(terminated_mul_stream.(:do))

  enable_disable_mul_stream =
    choice([do_block, ignore(dont_block)]) |> repeat() |> wrap() |> map({Enum, :sum, []})

  # is there a better way to do this? some sort of meta programming?
  defparsec(:dont, dont)
  defparsec(:do, do_)

  defparsecp(:part1_parse, greedy_mul_stream)

  defparsecp(:mul_parse_enable, enable_disable_mul_stream)
end
