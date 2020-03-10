defmodule Msmarket.Repo.Migrations.CreateRatings do
  use Ecto.Migration

  def change do
    create table(:ratings, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :item_id, references(:items, on_delete: :delete_all, on_update: :update_all, type: :binary_id), null: false
      add :user_id, references(:users, on_delete: :delete_all, on_update: :update_all, type: :binary_id), null: false
      add :description, :text
      add :value, :integer, null: false

      timestamps()
    end

    create unique_index(:ratings, [:item_id, :user_id])
    create constraint(:ratings, "rating_must_be_1_to_5_value", check: "1 <= value and value <= 5")

  end
end
