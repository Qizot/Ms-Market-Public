defmodule Msmarket.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def up do
    create table(:roles, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :role, :string

      timestamps()
    end

    flush()

    alias Msmarket.RoleContext

    RoleContext.create_role(%{role: "admin"})
  end

  def down do
    drop table(:roles)
  end
end
