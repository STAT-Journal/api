defmodule StatWeb.Resolvers.Mosiacs do
  def participate_in_mosaic(_,
    %{mosaic_participation: %{mosaic_id: mosaic_id}},
    %{context: %{current_user: user}}) do
    {:ok, nil}
  end
end
