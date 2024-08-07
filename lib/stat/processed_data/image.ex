defmodule Stat.ProcessedData.Image do
  use Ecto.Schema

  schema "processed_data_images" do
    field :url, :string
    field :processed_image, :string
    field :description, :string
    field :nsfw, :float
  end

end
