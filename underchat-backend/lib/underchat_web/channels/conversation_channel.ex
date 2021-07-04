defmodule UnderChatWeb.ConversationChannel do
  use Phoenix.Channel
  alias UnderChat.Conversations
  alias UnderChat.Conversations.Message

  def join("conversation:" <> id_channel, _params, socket) do
    {:ok, assign(socket, :discussion_id, id_channel)}
  end

  def handle_in("conversation:user_is_typing", _params, socket) do
    broadcast(socket, "conversation:someone_is_typing", %{
      discussion_id: socket.assigns.discussion_id,
      user_id: socket.assigns.user_id
    })

    {:noreply, socket}
  end

  def handle_in("conversation:user_stop_typing", _params, socket) do
    broadcast(socket, "conversation:someone_remove_typing", %{
      discussion_id: socket.assigns.discussion_id,
      user_id: socket.assigns.user_id
    })

    {:noreply, socket}
  end

  def handle_in("conversation:send_new_message", params, socket) do
    discussion =
      socket
      |> current_discussion_id
      |> Conversations.get_conversation!()

    conversation_pivot_user =
      current_discussion_id(socket)
      |> Conversations.get_conversation_user_by_conversation_and_user_ids!(
        current_user_id(socket)
      )

    %{"content" => msg_content} = params

    changeset =
      discussion
      |> Ecto.build_assoc(:messages)
      |> Message.changeset(%{
        content: msg_content,
        from_id: current_user_id(socket)
      })

    case UnderChat.Repo.insert(changeset) do
      {:ok, message} ->
        conversation_pivot_user
        |> Conversations.update_conversation_user(%{
          read_at: DateTime.utc_now()
        })

        broadcast(socket, "conversation:alert:new_messages", %{
          message: message
        })

        {:noreply, socket}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  def handle_in(
        "conversation:mark_read_messages",
        %{"discussion_id" => discussion_id},
        socket
      ) do
    current_user_id = current_user_id(socket)

    conversation_pivot_user =
      discussion_id
      |> Conversations.get_conversation_user_by_conversation_and_user_ids!(
        current_user_id
      )

    case conversation_pivot_user do
      nil ->
        {:noreply, socket}

      conversation_user ->
        case conversation_user
             |> Conversations.update_conversation_user(%{
               read_at: DateTime.utc_now()
             }) do
          {:ok, conversation_user_updated} ->
            broadcast(socket, "conversation:hey_someone_read_messages", %{
              discussion_id: discussion_id,
              user_id: socket.assigns.user_id,
              read_at: conversation_user_updated.read_at
            })

            {:reply, :ok, socket}
            {:error, conversation_user_updated}
            {:reply, {:error, %{errors: conversation_user_updated}}, socket}
        end
    end
  end

  defp current_user_id(socket) do
    socket.assigns.user_id
  end

  defp current_discussion_id(socket) do
    socket.assigns.discussion_id
  end
end
