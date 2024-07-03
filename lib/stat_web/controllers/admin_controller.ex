defmodule StatWeb.AdminController do
  use StatWeb, :controller

  alias Stat.PeriodicConsumablesScheduler

  # Sets the current user as an admin
  # This should only be enabled in Dev, QA, and Staging!
  def create_admin(conn, _params) do
    current_user = conn.assigns.current_user
    current_user.id
    |> Stat.Roles.make_user_admin()
    |> put_flash(:info, "User is now an admin")
    |> redirect(to: ~p"/")
  end

  def run_periodic_consumables_scheduler(conn, _params) do
    PeriodicConsumablesScheduler.run()
    conn
    |> put_flash(:info, "Periodic consumables scheduler run")
    |> redirect(to: ~p"/admin")
  end

  def index(conn, _params) do
    render(
      conn,
      :index,
      users: Stat.Accounts.list_users(),
      transactions: Stat.Consumables.list_transactions(),
    )
  end
end
