defmodule UnderChat.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :content, :string
      add :is_deleted, :boolean, default: false, null: false
      add :from_id, references(:users, on_delete: :delete_all, type: :binary_id)
      add :conversation_id, references(:conversations, on_delete: :delete_all, type: :binary_id)

      timestamps()
    end

    create index(:messages, [:from_id])
    create index(:messages, [:conversation_id])
  end
end
