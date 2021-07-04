defmodule UnderChat.Conversations.ConversationUser do
  use Ecto.Schema
  import Ecto.Changeset

  defimpl Jason.Encoder, for: WhatChat.Discussions.ConversationUser do
    def encode(value, options) do
      cond do
        Ecto.assoc_loaded?(value.conversation) &&
            Ecto.assoc_loaded?(value.user) ->
          Jason.Encode.map(
            Map.take(value, [
              :id,
              :read_at,
              :user,
              :user_id,
              :conversation,
              :conversation_id
            ]),
            options
          )

        !Ecto.assoc_loaded?(value.conversation) &&
            Ecto.assoc_loaded?(value.user) ->
          Jason.Encode.map(
            Map.take(value, [:id, :read_at, :user, :user_id]),
            options
          )

        Ecto.assoc_loaded?(value.conversation) &&
            !Ecto.assoc_loaded?(value.user) ->
          Jason.Encode.map(
            Map.take(value, [:id, :read_at, :conversation, :conversation_id]),
            options
          )

        !Ecto.assoc_loaded?(value.conversation) &&
            !Ecto.assoc_loaded?(value.user) ->
          Jason.Encode.map(Map.take(value, [:id, :read_at]), options)
      end
    end
  end

  schema "conversation_user" do
    field :read_at, :naive_datetime

    belongs_to(:user, UnderChat.Accounts.User)
    belongs_to(:conversation, UnderChat.Conversations.Conversation)
  end

  def changeset(conversation_user, attrs) do
    conversation_user
    |> cast(attrs, [:read_at, :conversation_id, :user_id])
    |> validate_required([:read_at])
  end
end
