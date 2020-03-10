defmodule Msmarket.Repo.Migrations.CreateUserRoles do
  use Ecto.Migration

  def change do
    create table(:user_roles, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all, type: :binary_id), null: false
      add :role_id, references(:roles, on_delete: :delete_all, type: :binary_id), null: false

      timestamps()
    end

    create index(:user_roles, [:user_id])
    create index(:user_roles, [:role_id])
    create unique_index(:user_roles, [:user_id, :role_id])

    # user_id = "d38049d1-d253-4112-8c70-06f9ee791848"
    # role_id = "9d9681e4-da45-4867-8d14-b1b612353912"

  end
end
