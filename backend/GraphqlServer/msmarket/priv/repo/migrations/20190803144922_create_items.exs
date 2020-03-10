defmodule Msmarket.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :description, :text, null: false
      add :image_url, :string
      add :item_category, :string, null: false
      add :contract_category, :string, null: false
      add :expires_at, :naive_datetime
      add :owner_id, references(:users, on_delete: :delete_all, on_update: :update_all, type: :binary_id)
      timestamps()
    end

    create index(:items, [:owner_id])
    create unique_index(:items, [:image_url])
    create unique_index(:items, [:owner_id, :name])

  end
end
