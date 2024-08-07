defmodule Stat.Guardian do
  use Guardian,
    otp_app: :stat

  def subject_for_token(%{id: id}, %{typ: "room"}) do
    sub = "room:#{to_string(id)}"
    {:ok, sub}
  end

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, "Invalid subject"}
  end

  def resource_from_claims(%{"sub" => id, "typ" => "room"}) do
    Stat.Room.get_room!(id)
  end

  def resource_from_claims(%{"sub" => id}) do
    Stat.Accounts.get_user_by_id(id)
  end

  def resource_from_claims(_) do
    {:error, "Invalid claims"}
  end

  def after_encode_and_sign(resource, claims = %{typ: "refresh"}, token, _options) do
    case Guardian.DB.after_encode_and_sign(resource, claims["typ"], claims, token) do
      {:ok, token} -> {:ok, token}
      {:error, _msg} ->
        {:error, :token_storage_failure}
    end
  end

  def after_encode_and_sign(_, _, token, _) do
    {:ok, token}
  end

  def on_verify(claims = %{typ: "refresh"}, token, _options) do
    with {:ok, _} <- Guardian.DB.on_verify(claims, token) do
      {:ok, claims}
    end
  end

  def on_verify(claims, _, _) do
    {:ok, claims}
  end

  def on_revoke(claims = %{typ: "refresh"}, token, _options) do
    with {:ok, _} <- Guardian.DB.on_revoke(claims, token) do
      {:ok, claims}
    end
  end

  def on_revoke(claims, _, _) do
    {:ok, claims}
  end
end
