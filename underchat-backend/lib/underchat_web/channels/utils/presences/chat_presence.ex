defmodule UnderChatWeb.ChatPresence do
  use Phoenix.Presence, otp_app: :underchat, pubsub_server: UnderChat.PubSub

  alias UnderChatWeb.{ChatPresence}

  def track_user_join(socket, user) do
    ChatPresence.track(socket, user.id, %{
      typing: false,
      conversation_id: 0,
      last_seen: DateTime.utc_now(),
      image: user.image,
      username: user.username,
      email: user.email,
      id: user.id
    })
  end

  def track_user_update(socket, id_user, user) do
    ChatPresence.update(socket, user.id, %{
      typing: false,
      conversation_id: 0,
      last_seen: DateTime.utc_now(),
      image: user.image,
      username: user.username,
      email: user.email,
      id: id_user
    })
  end
end
