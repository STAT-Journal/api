defmodule Stat.Consumables do
  import Ecto.Query, warn: false
  alias Stat.Repo
  alias Stat.Consumables.{StickerType, Transaction, Balance}

  def get_sticker_types do
    Repo.all(StickerType)
  end

  def get_sticker_type(id) do
    Repo.get(StickerType, id)
  end

  def get_balance(user) do
    Repo.get_by!(Balance, user_id: user.id)
  end

  def get_and_lock_balance(user) do
    Balance |> where(user_id: ^user.id) |> lock("FOR UPDATE") |> Repo.one!()
  end

  def change_balance(user, amount) do
    user_balance = get_and_lock_balance(user)

    new_balance = user_balance.balance + amount

    user_balance
    |> Balance.changeset(%{balance: new_balance})
    |> Repo.update()
  end

  def create_balance(user) do
    %Balance{user_id: user.id, balance: 0}
    |> Repo.insert!()
  end

  def buy_sticker(user, sticker_type) do
    transaction = %Transaction{currency_change: -sticker_type.price, user_id: user.id, sticker_type_id: sticker_type.id}

    Repo.transaction(fn ->
      Repo.insert!(transaction)
      change_balance(user, -sticker_type.price)
    end)
  end

  def list_transactions(user) do
    Transaction
    |> where(user_id: ^user)
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end
end
