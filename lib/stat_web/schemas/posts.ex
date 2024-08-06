defmodule StatWeb.Schemas.Posts do
  use Absinthe.Schema.Notation

  object :text_post do
    field :body, non_null(:string)
    field :inserted_at, non_null(:string) # ISO8601
  end

  object :weekly_check_in do
    field :year, :integer
    field :week_number, :integer
  end

  enum :moment_type do
    value :good
    value :bad
  end

  object :moment_graph_item do
    field :inserted_at, non_null(:string) # ISO8601
    field :good, :integer
    field :bad, :integer
  end

  object :moment do
    field :type, non_null(:moment_type)
    field :inserted_at, non_null(:string) # ISO8601
  end
end
