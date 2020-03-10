defmodule Msmarket.UserContext do
  @moduledoc """
  The UserContext context.
  """

  import Ecto.Query, warn: false
  alias Msmarket.Repo

  alias Msmarket.UserContext.User
  alias Msmarket.DSNETImporter
  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  def list_mock_users do
    from(u in User, where: like(u.email, "%@mock.com"))
    |> Repo.all
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)
  def get_user(id), do: Repo.get(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  defp create_user_from_dsnet_token(token) do
    with %{"tenant_id" => tenant_id, "name" => name, "surname" => surname} <- DSNETImporter.get_user_data(:user_info, token: token),
         %{"email" => email, "phone" => phone} <- DSNETImporter.get_user_data(:personal_info, token: token),
         %{"dormitory" => dormitory, "room" => room} <- DSNETImporter.get_user_data(:accommodation, token: token) do
          %{
            tenant_id: tenant_id,
            name: name,
            surname: surname,
            email: email,
            phone: phone,
            dormitory: dormitory,
            room: room
          }
          |> create_user
    else
      _ -> {:error, "couldn't fetch user data from dsnet"}
    end
  end

  def get_or_create_user(token) do
    case DSNETImporter.get_user_data(:user_info, token: token) do
      %{"tenant_id" => tenant_id} ->
        with {:ok, user} when not is_nil(user) <- {:ok, Repo.one(from(u in User, where: u.tenant_id == ^tenant_id)) } do
          {:ok, user}
        else
          {:ok, nil} -> create_user_from_dsnet_token(token)
        end
      {:error, reason} -> {:error, reason}
    end
  end

  def authenticate_user(code) do
    case DSNETImporter.access_dsnet_token(code: code) do
      {:ok, token} -> get_or_create_user(token)
      {:error, reason} -> {:error, reason}
    end
  end

  def refresh_user(token: token) do
    with %{"tenant_id" => tenant_id, "name" => name, "surname" => surname} <- DSNETImporter.get_user_data(:user_info, token: token),
         %{"email" => email, "phone" => phone} <- DSNETImporter.get_user_data(:personal_info, token: token),
         %{"dormitory" => dormitory, "room" => room} <- DSNETImporter.get_user_data(:accommodation, token: token) do
          user = Repo.one(from u in User, where: u.tenant_id == ^tenant_id)
          attrs = %{
            tenant_id: tenant_id,
            name: name,
            surname: surname,
            email: email,
            phone: phone,
            dormitory: dormitory,
            room: room
          }
          update_user(user, attrs)
    else
      {:error, reason} -> {:error, reason}
      _ -> {:error, "couldn't fetch user data from dsnet"}
    end
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end
end
