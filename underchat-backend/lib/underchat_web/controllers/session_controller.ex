defmodule UnderChatWeb.SessionController do
  use UnderChatWeb, :controller

  plug UnderChatWeb.Plugs.Auth when action in [:delete]

  def create(conn, %{"email" => email, "password" => password}) do
    case WhatChat.Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> put_session(:current_user, user)
        |> put_status(:ok)
        |> put_view(UnderChatWeb.UserView)
        |> render("sign_in.json", user: user)

      {:error, message} ->
        conn
        |> delete_session(:current_user)
        |> put_status(:unauthorized)
        |> put_view(UnderChatWeb.ErrorView)
        |> render("401.json", message: message)
    end
  end

  def ping(conn, _params) do
    case get_session(conn, :current_user) do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> put_view(UnderChatWeb.ErrorView)
        |> render("401.json", message: "Você não está logado!")

      user ->
        conn
        |> put_status(:ok)
        |> put_view(UnderChatWeb.UserView)
        |> render("show.json", user: user)
    end
  end

  def delete(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> put_status(:ok)
    |> put_view(UnderChatWeb.UserView)
    |> render("sign_out.json", message: "Deslogado com sucesso.")
  end
end
