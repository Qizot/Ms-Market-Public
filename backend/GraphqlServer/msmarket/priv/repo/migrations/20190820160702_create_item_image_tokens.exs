defmodule Msmarket.Repo.Migrations.CreateItemImageTokens do
  use Ecto.Migration

  def change do
    create table(:item_image_tokens, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :token, :string, null: false
      add :item_id, references(:items, on_delete: :delete_all, on_update: :update_all, type: :binary_id), null: false

      timestamps()
    end

    create unique_index(:item_image_tokens, [:item_id])
  end
end
