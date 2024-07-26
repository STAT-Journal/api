defmodule StatWeb.Middlewares.ConvertDatetime do
  @behaviour Absinthe.Middleware

  def call(resolution, _) do
    %{resolution |
      value: convert_datetime(resolution.value)
    }
  end

  defp convert_datetime(%{inserted_at: _} = result) do
    Map.update!(result, :inserted_at, &DateTime.to_iso8601/1)
  end
end
