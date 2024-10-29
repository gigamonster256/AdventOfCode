defmodule Mix.Tasks.Fmt do
  @moduledoc """
  A custom alias for `mix format`.
  """

  use Mix.Task

  @shortdoc "Formats your code (alias for `mix format`)."

  def run(args) do
    # Call the original `mix format` task with the given arguments
    Mix.Tasks.Format.run(args)
  end
end
