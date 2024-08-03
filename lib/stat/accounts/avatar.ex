defmodule Stat.Accounts.Avatar do
  use Ecto.Schema
  import Ecto.Changeset

  schema "avatars" do
    field :version, Ecto.Enum, values: [nine: 9], default: :nine
    field :style, :string
    field :options, :string

    belongs_to :user, Stat.Accounts.User
    timestamps(type: :utc_datetime)
  end

  def avatar_endpoint do
    Application.get_env(:stat, Stat.Accounts)[:dicebear_api]
  end

  def check_avatar({:ok, options}, version, style) do
    version_digit = Ecto.Enum.mappings(__MODULE__, :version)[version]
    query = "/#{version_digit}.x/#{style}/svg" <> "?" <> URI.encode_query(options)
    IO.inspect(avatar_endpoint() <> query)
    Req.get(avatar_endpoint() <> query)
    |> case do
      {:ok, %{status: 200}} -> :ok
      {:ok, _} -> {:error, "Avatar not found"}
      {:error, _} -> {:error, "Avatar not found"}
    end
  end

  def check_avatar(_, _, _) do
    {:error, "Invalid options"}
  end

  def validate_avatar(changeset) when changeset.valid? do
    version = get_field(changeset, :version)
    style = get_field(changeset, :style)
    options = get_field(changeset, :options)
    Jason.decode(options)
    |> check_avatar(version, style)
    |> case do
      :ok -> changeset
      {:error, msg} -> add_error(changeset, :avatar, msg)
    end
  end

  def validate_avatar(changeset) do
    changeset
  end

  def changeset(avatar, attrs) do
    avatar
    |> cast(attrs, [:style, :options])
    |> validate_required([:style, :options])
    |> validate_format(:style, ~r/^[a-z-0-9]+$/, message: "can only contain lowercase letters, numbers, and hyphens")
    |> validate_avatar()
    |> unique_constraint(:user_id, message: "already has an avatar")
  end
end
