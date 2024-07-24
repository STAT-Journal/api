defmodule StatWeb.Middlewares.HandleBadAuth do
  @behaviour Absinthe.Middleware

  def call(resolution, _) do
    case resolution.context do
      %{current_user: :error} ->
        resolution
        |> Absinthe.Resolution.put_result({:error, "Invalid Authentication"})
      _ ->
        # If later pipeline requires auth, fail there
        resolution
    end
  end
end
