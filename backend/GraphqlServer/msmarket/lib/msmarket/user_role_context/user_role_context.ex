defmodule Msmarket.UserRoleContext do
  @moduledoc """
  The UserRoleContext context.
  """

  import Ecto.Query, warn: false
  alias Msmarket.Repo

  alias Msmarket.UserRoleContext.UserRole

  @doc """
  Returns the list of user_roles.

  ## Examples

      iex> list_user_roles()
      [%UserRole{}, ...]

  """
  def list_user_roles do
    Repo.all(UserRole)
  end

  def get_user_roles(user_id: user_id) do
    from(ur in UserRole, where: ur.user_id == ^user_id, preload: :roles)
    |> Repo.all
    |> Enum.map(&(&1.roles))
  end


  @doc """
  Creates a user_role.

  ## Examples

      iex> create_user_role(%{field: value})
      {:ok, %UserRole{}}

      iex> create_user_role(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_role(attrs \\ %{}) do
    %UserRole{}
    |> UserRole.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_role.

  ## Examples

      iex> update_user_role(user_role, %{field: new_value})
      {:ok, %UserRole{}}

      iex> update_user_role(user_role, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_role(%UserRole{} = user_role, attrs) do
    user_role
    |> UserRole.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a UserRole.

  ## Examples

      iex> delete_user_role(user_role)
      {:ok, %UserRole{}}

      iex> delete_user_role(user_role)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_role(%UserRole{} = user_role) do
    Repo.delete(user_role)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_role changes.

  ## Examples

      iex> change_user_role(user_role)
      %Ecto.Changeset{source: %UserRole{}}

  """
  def change_user_role(%UserRole{} = user_role) do
    UserRole.changeset(user_role, %{})
  end
end
