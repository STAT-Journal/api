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

  enum :moment_type do
    value :good
    value :bad
  end

  object :moment do
    field :type, :moment_type
    field :inserted_at, :string # ISO8601
  end
end
