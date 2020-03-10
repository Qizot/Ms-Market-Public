defmodule Msmarket.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :surname, :string, null: false
      add :email, :string, null: false
      add :tenant_id, :integer, null: false
      add :phone, :string
      add :dormitory, :string
      add :room, :string

      timestamps()
    end

    create unique_index(:users, [:email])
    create unique_index(:users, [:tenant_id])

  end
end
