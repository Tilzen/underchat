defmodule UnderChatWeb.ConversationPresence do
  use Phoenix.Presence,
    otp_app: :underchat,
    pubsub_server: UnderChat.PubSub
end
