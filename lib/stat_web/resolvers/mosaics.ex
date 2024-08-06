defmodule StatWeb.Resolvers.Mosaics do
  def participate_in_mosaic(_,
    %{mosaic_participation: %{mosaic_id: mosaic_id}},
    %{context: %{current_user: user}}) do
    Stat.Servers.MosaicInstance.receive_participation(mosaic_id, user)
  end
end
