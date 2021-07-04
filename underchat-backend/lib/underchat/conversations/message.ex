defmodule UnderChat.Conversations.Message do
  use Ecto.Schema
  import Ecto.Changeset

  alias UnderChat.Conversations.Conversation

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @derive {Jason.Encoder,
           only: [
             :id,
             :content,
             :is_deleted,
             :from_id,
             :conversation_id,
             :inserted_at,
             :updated_at
           ]}
  schema "messages" do
    field :content, :string
    field :is_deleted, :boolean, default: false
    field :from_id, :binary_id

    belongs_to(:conversations, Conversation, foreign_key: :conversation_id)

    timestamps()
  end

  def changeset(message, attrs) do
    message
    |> cast(attrs, [:content, :is_deleted])
    |> validate_required([:content, :is_deleted])
  end
end
