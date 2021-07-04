defmodule UnderChat.Repo.Migrations.CreateConversations do
  use Ecto.Migration

  def change do
    create table(:conversations, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :profile, :string

      timestamps()
    end
  end
end
