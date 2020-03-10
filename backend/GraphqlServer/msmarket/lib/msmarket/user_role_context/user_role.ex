defmodule Msmarket.UserRoleContext.UserRole do
  use Ecto.Schema
  import Ecto.Changeset
  alias Msmarket.UserContext.User
  alias Msmarket.RoleContext.Role

  @primary_key false
  @foreign_key_type :binary_id
  schema "user_roles" do
    belongs_to :users, User, foreign_key: :user_id
    belongs_to :roles, Role, foreign_key: :role_id
    timestamps()
  end

  @doc false
  def changeset(user_role, attrs) do
    user_role
    |> cast(attrs, [:user_id, :role_id])
    |> validate_required([:user_od, :role_id])
  end
end
