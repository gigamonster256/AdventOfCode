defmodule AdventOfCode.Solution.Year2024.Day09 do
  use AdventOfCode.Solution.SharedParse

  @impl true
  def parse(input) do
    nums =
      input
      |> String.trim()
      |> String.split("", trim: true)

    files =
      Stream.take_every(nums, 2)
      |> Stream.map(&String.to_integer/1)
      |> Enum.with_index()

    spaces =
      Stream.drop_every(nums, 2)
      |> Enum.map(&String.to_integer/1)

    {files, spaces}
  end

  def part1(input) do
    {files, spaces} = input

    total_length =
      files
      |> Stream.map(&elem(&1, 0))
      |> Enum.sum()

    rev = Enum.reverse(files)

    files
    |> Stream.zip(spaces)
    |> Stream.flat_map(&Tuple.to_list/1)
    |> Stream.transform(rev, fn slot, rev ->
      case slot do
        # original data
        {num, idx} ->
          # yield idx num times
          nums = Stream.cycle([idx]) |> Enum.take(num)
          {nums, rev}

        # empty space
        spaces ->
          get_spaces_from_rev(rev, spaces)
      end
    end)
    |> Stream.take(total_length)
    |> Stream.with_index()
    |> Stream.map(&Tuple.product/1)
    |> Enum.sum()
  end

  def part2(input) do
    {files, spaces} = input

    rev = Enum.reverse(files)

    files
    |> Stream.zip(spaces)
    |> Stream.flat_map(&Tuple.to_list/1)
    |> Stream.transform({rev, MapSet.new([])}, fn slot, {rev, eliminated} ->
      case slot do
        # original data
        {num, idx} ->
          # number was already compacted
          if MapSet.member?(eliminated, idx) do
            # try to fill its space
            get_spaces_from_rev_no_frag(rev, num, eliminated)
          else
            # yield idx num times
            nums = Stream.cycle([idx]) |> Enum.take(num)
            eliminated = MapSet.put(eliminated, idx)
            {nums, {rev, eliminated}}
          end

        # empty space
        spaces ->
          get_spaces_from_rev_no_frag(rev, spaces, eliminated)
      end
    end)
    |> Stream.with_index()
    |> Stream.map(&Tuple.product/1)
    |> Enum.sum()
  end

  defp get_spaces_from_rev(rev, spaces, acc \\ []) do
    # we have num amount of idx and we need spaces amount of spaces
    [{num, idx} | new_rev] = rev

    cond do
      # we have enough nums to fulfill the spaces
      num > spaces ->
        # take spaces amount of idx
        nums = Stream.cycle([idx]) |> Enum.take(spaces)
        leftover = num - spaces
        {acc ++ nums, [{leftover, idx} | new_rev]}

      # we have exactly enough nums to fulfill the spaces
      num == spaces ->
        nums = Stream.cycle([idx]) |> Enum.take(spaces)
        {acc ++ nums, new_rev}

      # we need to take all the nums and some from the next
      num < spaces ->
        nums = Stream.cycle([idx]) |> Enum.take(num)
        get_spaces_from_rev(new_rev, spaces - num, acc ++ nums)
    end
  end

  defp get_spaces_from_rev_no_frag(rev, spaces, eliminated, acc \\ {[], []})

  defp get_spaces_from_rev_no_frag([], spaces, eliminated, {acc, rev_left}) do
    # fill in the rest of the spaces with 0
    acc = acc ++ (Stream.cycle([0]) |> Enum.take(spaces))
    rev_left = rev_left |> Enum.reverse()

    {acc, {rev_left, eliminated}}
  end

  defp get_spaces_from_rev_no_frag(rev, spaces, eliminated, {acc, rev_left}) do
    # we have num amount of idx and we need spaces amount of spaces
    [{num, idx} | new_rev] = rev

    cond do
      # if we have eliminated this idx, skip
      MapSet.member?(eliminated, idx) ->
        get_spaces_from_rev_no_frag(new_rev, spaces, eliminated, {acc, rev_left})

      # we have too many nums... try the next number
      num > spaces ->
        rev_left = [{num, idx} | rev_left]
        # do not fragment the list (keep spaces)
        get_spaces_from_rev_no_frag(new_rev, spaces, eliminated, {acc, rev_left})

      # we have exactly enough nums to fulfill the spaces
      num == spaces ->
        acc = acc ++ (Stream.cycle([idx]) |> Enum.take(spaces))
        eliminated = MapSet.put(eliminated, idx)
        rev_left = (rev_left |> Enum.reverse()) ++ new_rev

        {acc, {rev_left, eliminated}}

      # we need to take all the nums and some from the next
      num < spaces ->
        spaces = spaces - num
        eliminated = MapSet.put(eliminated, idx)
        acc = acc ++ (Stream.cycle([idx]) |> Enum.take(num))

        get_spaces_from_rev_no_frag(new_rev, spaces, eliminated, {acc, rev_left})
    end
  end
end
