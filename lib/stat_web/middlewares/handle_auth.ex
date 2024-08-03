defmodule StatWeb.Middlewares.HandleAuth do
  @behaviour Absinthe.Middleware

  def call(resolution, _) do
    case resolution.context do
      %{current_user: :error} ->
        resolution
        |> Absinthe.Resolution.put_result({:error, "Invalid Authentication"})
      _ ->
        resolution
  end
  end
end
