defmodule UnderChatWeb.UserSocket do
  use Phoenix.Socket

  channel "conversation:*", UnderChatWeb.ConversationChannel

  channel "users:*", UnderChatWeb.UsersChannel

  def connect(%{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "key", token, max_age: 86400) do
      {:ok, user_id} ->
        user =
          UnderChat.Accounts.get_user!(user_id)
          |> UnderChat.Repo.preload(:conversations)

        {:ok,
         assign(socket, :user_id, user_id)
         |> assign(:user, user)}

      {:error, _reason} ->
        :error
    end
  end

  def connect(_params, _socket), do: :error

  def id(socket) do
    "users_socket:#{socket.assigns.user_id}"
  end
end
