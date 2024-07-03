defmodule Stat.Consumables do
  import Ecto.Query, warn: false
  alias Stat.Repo
  alias Stat.Consumables.{StickerType, Transaction}

  def get_sticker_types do
    Repo.all(StickerType)
  end

  def get_sticker_type!(id) do
    Repo.get!(StickerType, id)
  end

  def give_sticker(user_id, sticker_type_id, amount) do
    %Transaction{user_id: user_id, sticker_type_id: sticker_type_id, change: amount}
    |> Repo.insert()
  end

  def give_random_sticker(user_id) do
    sticker_type = Repo.one(from s in StickerType, order_by: fragment("RANDOM()"), limit: 1)
    give_sticker(user_id, sticker_type.id, 1)
  end

  def get_users_inventory(user_id) do
    Repo.all(from t in Transaction, where: t.user_id == ^user_id)
    |> group_by([t], t.sticker_type_id)
    |> select([t], %{sticker_type_id: t.sticker_type_id, total: sum(t.change)})
    # todo: group by type of consumable (sticker, other consumable, etc.)
  end

  def list_transactions(count \\ 100) do
    Repo.all(from t in Transaction, limit: ^count)
  end
end
