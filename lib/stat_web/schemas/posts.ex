defmodule StatWeb.Schemas.Posts do
  use Absinthe.Schema.Notation

  object :text_post do
    field :body, :string
    field :user, :user
  end

  object :weekly_check_in do
    field :year, :integer
    field :week_number, :integer
  end

  object :moment do
    field :type, :string
    field :user, :user
  end
end
