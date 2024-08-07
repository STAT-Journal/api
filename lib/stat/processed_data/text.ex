defmodule Stat.ProcessedData.Text do
  use Ecto.Schema

  schema "processed_data_texts" do
    field :text, :string
    field :processed_text, :string
    field :valence, :float
    field :arousal, :float
    field :dominance, :float
    field :emotion, :string
    field :nsfw, :float
  end
end
