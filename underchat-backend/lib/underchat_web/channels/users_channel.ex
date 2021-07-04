defmodule UnderChatWeb.UsersChannel do
  use Phoenix.Channel
  alias UnderChatWeb.ChatPresence
  alias UnderChat.Repo
  alias UnderChat.Conversations

  defp filtered_user_info(
         %{
           id: id,
           email: email,
           username: username,
           image: image,
           inserted_at: inserted_at
         },
         discussion_id
       ) do
    conversation_pivot_user =
      discussion_id
      |> Conversations.get_conversation_user_by_conversation_and_user_ids!(id)

    %{
      id: id,
      email: email,
      username: username,
      image: image,
      inserted_at: inserted_at,
      read_at: conversation_pivot_user.read_at
    }
  end

  defp put_is_group(conversation) do
    is_group = conversation.profile !== nil

    conversation
    |> Map.put(:is_group, is_group)
  end

  defp parse_it(conversation) do
    users =
      Enum.map(
        conversation.users,
        fn user -> filtered_user_info(user, conversation.id) end
      )

    conversation
    |> put_is_group
    |> Map.put(:users, users)
  end

  def join("users:join", _params, socket) do
    _user_id = socket.assigns.user_id

    Conversations =
      socket.assigns.user
      |> Repo.preload(conversations: [:users, :messages])

    user_Conversations =
      Enum.map(
        Conversations.list_conversations(),
        fn conversation -> parse_it(conversation) end
      )

    send(self(), :after_join)

    {:ok, %{conversations: user_Conversations}, socket}
  end

  def handle_info(:after_join, socket) do
    ChatPresence.track_user_join(socket, current_user(socket))
    presences = ChatPresence.list(socket)

    push(socket, "presence_state", presences)

    {:noreply, socket}
  end

  def handle_in("users:declare", %{"userInfo" => userInfo}, socket) do
    broadcast!(socket, "users:joined", %{NewUserInfo: userInfo})
    {:reply, :ok, socket}
  end

  def handle_in(
        "users:new_conversation",
        %{"contact_id" => _contact_id},
        socket
      ) do
    {:reply, :ok, socket}
  end

  def current_user(socket) do
    socket.assigns.user
  end
end
