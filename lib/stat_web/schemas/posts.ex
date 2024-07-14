defmodule StatWeb.Schemas.Posts do
  use Absinthe.Schema.Notation

  object :text_post do
    field :id, :id
    field :body, :string
    field :user, :user
  end
end
