defmodule StatWeb.UserConfirmationController do
  use StatWeb, :controller

  alias Stat.Accounts

  def mobile_redirect_base do
    Application.get_env(:stat, StatWeb.UserConfirmationController)[:mobile_redirect_base]
  end

  def desktop_redirect_base do
    Application.get_env(:stat, StatWeb.UserConfirmationController)[:desktop_redirect_base]
    || ~p"/webapp/login/token"
  end

  def redirect_to_signin(conn = %{assigns: %{useragent_type: :mobile}}, redirect_query_params) do
    conn
    |> redirect(external: mobile_redirect_base() <> "?" <> redirect_query_params)
  end


  def redirect_to_signin(conn = %{assigns: %{useragent_type: :desktop}}, redirect_query_params) do
    case desktop_redirect_base() do
      path = "http" <> _ ->
        conn
        |> redirect(external: path <> "?" <> redirect_query_params)
      path ->
        conn
        |> redirect(to: path <> "?" <> redirect_query_params)
    end
  end

  def redirect_to_signin({conn, _, _}) do
    conn
    |> redirect(to: ~p"/verify/not_found")
  end

  def fetch_useragent_type(conn) do
    conn
    |> assign(:useragent_type, Browser.device_type(conn))
  end

  def create(conn, %{"token" => token}) do
    case Accounts.sign_in_user_by_token(token) do
      {:ok, token, claims} ->
        {:ok, claims_json} = Jason.encode(claims)
        redirect_query_params = URI.encode_query(%{"token" => token, "claims" => claims_json})
        conn
        |> fetch_useragent_type()
        |> redirect_to_signin(redirect_query_params)
      {:error, _msg} ->
        conn
        |> redirect(to: ~p"/verify/not_found")
    end
  end

  def not_found(conn, _params) do
    conn
    |> put_status(404)
    |> render(:not_found)
  end
end
