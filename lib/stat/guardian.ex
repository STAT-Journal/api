defmodule Stat.Guardian do
  alias Stat.Accounts
  alias Stat.Repo
  import Stat.Queryable

  use Guardian, otp_app: :stat,
    permissions: %{
      default: [:user],
      admin: [:admin]
    }

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :reason_for_error}
  end

  def resource_from_claims(%{"sub" => id}) do
    Stat.Accounts.get_user_by_id(id)
  end

  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end
end
