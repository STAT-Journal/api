defmodule StatWeb.Resolvers.Consumables do
  alias Stat.Consumables

  def list_transactions(_, _, %{context: %{current_user: user}}) do
    Consumables.list_transactions(user.id)
  end

  def get_balance(_, _, %{context: %{current_user: user}}) do
    Consumables.get_balance(user)
  end

  def get_balance(_, _, _) do
    {:error, "You must be logged in to view your balance"}
  end

  def buy_sticker(_, %{sticker_type_id: sticker_type_id}, %{context: %{current_user: user}}) do
    sticker = Consumables.get_sticker_type(sticker_type_id)

    case Consumables.buy_sticker(user, sticker) do
      {:ok, _} -> {:ok, %{sticker: sticker}}
      {:error, changeset} -> {:error, changeset}
    end
  end

  def buy_sticker(_, _, _) do
    {:error, "You must be logged in to buy a sticker"}
  end
end
