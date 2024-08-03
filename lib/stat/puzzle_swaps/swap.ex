
defmodule Stat.PuzzleSwaps.Swap do
  use Ecto.Schema
  import Ecto.Changeset

  schema "puzzle_swap_swaps" do
    belongs_to :puzzle, Stat.PuzzleSwaps.Puzzle
    belongs_to :recipient, Stat.Accounts.User
    belongs_to :sender, Stat.Accounts.User
    field :piece, :integer # 0-indexed on a 2D square grid
  end

  def validate_piece_is_in_puzzle(changeset) do
    puzzle = changeset.data.puzzle
    piece = changeset.data.piece

    if piece < 0 || piece >= puzzle.difficulty * puzzle.difficulty do
      add_error(changeset, :piece, "is not a valid piece for this puzzle")
    else
      changeset
    end
  end

  def new_changeset(swap, attrs) do
    swap
    |> cast(attrs, [:puzzle_id, :sender_id, :piece])
    |> assoc_constraint(:puzzle)
    |> assoc_constraint(:sender)
    |> assoc_constraint(:recipient)
    |> validate_required([:puzzle_id, :sender_id, :piece])
    |> validate_piece_is_in_puzzle()
  end
end
