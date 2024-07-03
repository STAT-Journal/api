defmodule StatWeb.ConsumableController do
  use StatWeb, :controller
  alias Stat.Consumables

  def inventory(conn, %{"user_id" => user_id}) do
    inventory = Consumables.get_users_inventory(user_id)
    render(conn, :inventory, inventory: inventory)
  end
end
