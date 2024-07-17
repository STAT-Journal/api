defmodule StatWeb.UserRegistrationJSON do
  use StatWeb, :controller

  def render("confirmation.json", %{user: user}) do
    %{data: %{id: user.id, email: user.email}}
  end

  def render("new.json", %{changeset: changeset}) do
    %{errors: changeset.errors}
  end
end
