defmodule Msmarket.Repo.Migrations.CreateBorrowRequests do
  use Ecto.Migration

  def change do
    create table(:borrow_requests, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :item_id, references(:items, on_delete: :delete_all, on_update: :update_all, type: :binary_id), null: false
      add :user_id, references(:users, on_delete: :delete_all, on_update: :update_all, type: :binary_id), null: false
      add :status, :string

      timestamps()
    end

    create index(:borrow_requests, [:item_id])
    create index(:borrow_requests, [:user_id])

  end
end
