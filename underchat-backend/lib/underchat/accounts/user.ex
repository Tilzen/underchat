defmodule UnderChat.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @required_params [:username, :email, :password, :image]

  defimpl Jason.Encoder, for: UnderChat.Accounts.User do
    def encode(value, options) do
      if Ecto.assoc_loaded?(value.conversations) do
        Jason.Encode.map(
          Map.take(value, [
            :id,
            :email,
            :username,
            :read_at,
            :image,
            :inserted_at,
            :updated_at,
            :conversations
          ]),
          options
        )
      else
        Jason.Encode.map(
          Map.take(value, [
            :id,
            :email,
            :username,
            :read_at,
            :image,
            :inserted_at,
            :updated_at
          ]),
          options
        )
      end
    end
  end

  schema "users" do
    field :email, :string
    field :image, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :username, :string

    timestamps()
  end

  def changeset(user \\ %__MODULE__{}, params) do
    user
    |> cast(params, @required_params)
    |> validate_required(@required_params)
    |> unique_constraint(:email)
    |> hash_password()
  end

  defp hash_password(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, Argon2.add_hash(password))
  end

  defp hash_password(changeset), do: changeset
end
