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

    space =
      Stream.drop_every(nums, 2)
      |> Enum.map(&String.to_integer/1)

    {files, space}
  end

  def part1(input) do
    {files, space} = input

    total_length =
      files
      |> Stream.map(&file_name/1)
      |> Enum.sum()

    rev = Enum.reverse(files)

    files
    |> Stream.zip(space)
    |> Stream.flat_map(&Tuple.to_list/1)
    |> Stream.transform(rev, fn file_or_space, rev ->
      case file_or_space do
        # original file
        {file_len, file_name} ->
          # yield file_name file_len times
          nums = List.duplicate(file_name, file_len)
          {nums, rev}

        # empty space
        space ->
          fill_space(rev, space)
      end
    end)
    |> Stream.take(total_length)
    |> Stream.with_index()
    |> Stream.map(&Tuple.product/1)
    |> Enum.sum()
  end

  def part2(input) do
    {files, space} = input

    rev = Enum.reverse(files)

    files
    |> Stream.zip(space)
    |> Stream.flat_map(&Tuple.to_list/1)
    |> Stream.transform({rev, MapSet.new([])}, fn file_or_space, {rev, defragged} ->
      case file_or_space do
        # original file
        {file_len, file_name} ->
          # number was already compacted
          if MapSet.member?(defragged, file_name),
            # try to fill its space
            do: fill_space_no_frag(rev, file_len, defragged),
            else:
              (
                # yield file_name file_len times
                nums = List.duplicate(file_name, file_len)
                defragged = MapSet.put(defragged, file_name)
                {nums, {rev, defragged}}
              )

        # empty space
        space ->
          fill_space_no_frag(rev, space, defragged)
      end
    end)
    |> Stream.with_index()
    |> Stream.map(&Tuple.product/1)
    |> Enum.sum()
  end

  defp file_name({file_len, _file_name}), do: file_len

  defp fill_space(rev, space, acc \\ []) do
    # we have file_len amount of file_name and we need space amount of space
    [{file_len, file_name} | rev] = rev

    cond do
      # we have enough nums to fulfill the space
      file_len > space ->
        # take space amount of file_name
        acc = acc ++ List.duplicate(file_name, space)
        leftover = file_len - space

        {acc, [{leftover, file_name} | rev]}

      # we have exactly enough nums to fulfill the space
      file_len == space ->
        acc = acc ++ List.duplicate(file_name, space)

        {acc, rev}

      # we need to take all the nums and some from the next
      file_len < space ->
        acc = acc ++ List.duplicate(file_name, file_len)
        space = space - file_len

        fill_space(rev, space, acc)
    end
  end

  defp fill_space_no_frag(rev, space, defragged, acc \\ {[], []})

  defp fill_space_no_frag([], space, defragged, {acc, too_big}) do
    # fill in the rest of the space with 0
    acc = acc ++ List.duplicate(0, space)
    rev = too_big |> Enum.reverse()

    {acc, {rev, defragged}}
  end

  defp fill_space_no_frag(rev, space, defragged, {acc, too_big}) do
    # we have file_len amount of file_name and we need space amount of space
    [file | rev] = rev
    {file_len, file_name} = file

    cond do
      # if we have defragged this file_name, skip
      MapSet.member?(defragged, file_name) ->
        fill_space_no_frag(rev, space, defragged, {acc, too_big})

      # file is too big to fit in the space
      file_len > space ->
        too_big = [file | too_big]
        # do not fragment the list (keep space)
        fill_space_no_frag(rev, space, defragged, {acc, too_big})

      # file fits exactly in the space
      file_len == space ->
        acc = acc ++ List.duplicate(file_name, space)
        defragged = MapSet.put(defragged, file_name)
        rev = Enum.reverse(too_big) ++ rev

        {acc, {rev, defragged}}

      # file fits in the space and we have space left
      file_len < space ->
        space = space - file_len
        defragged = MapSet.put(defragged, file_name)
        acc = acc ++ List.duplicate(file_name, file_len)

        fill_space_no_frag(rev, space, defragged, {acc, too_big})
    end
  end
end
