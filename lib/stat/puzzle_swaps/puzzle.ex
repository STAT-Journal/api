defmodule Stat.PuzzleSwaps.Puzzle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "puzzle_swap_puzzles" do
    field :name, :string
    field :image, :string # URL to image
    field :difficulty, :integer # Defines the number of rows and columns (always will be a square)
  end
end
