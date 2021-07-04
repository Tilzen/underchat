defmodule UnderChatWeb.Plugs.Auth do
  import Plug.Conn
  import Phoenix.Controller

  def init(_params) do
  end

  def call(conn, _params) do
    if get_session(conn, :current_user) do
      conn
    else
      conn
      |> put_status(:unauthorized)
      |> put_view(UnderChatWeb.ErrorView)
      |> render("401.json", message: "Usuário não autenticado.")
      |> halt()
    end
  end
end
