defmodule Msmarket.UserContextTest do
  use Msmarket.DataCase

  alias Msmarket.UserContext

  describe "users" do
    alias Msmarket.UserContext.User

    # @valid_attrs %{dormitory: "some dormitory", email: "some email", name: "some name", phone: "some phone", room: "some room", surname: "some surname", tenant_id: 42}
    # @update_attrs %{dormitory: "some updated dormitory", email: "some updated email", name: "some updated name", phone: "some updated phone", room: "some updated room", surname: "some updated surname", tenant_id: 43}
    # @invalid_attrs %{dormitory: nil, email: nil, name: nil, phone: nil, room: nil, surname: nil, tenant_id: nil}

    # def user_fixture(attrs \\ %{}) do
    #   {:ok, user} =
    #     attrs
    #     |> Enum.into(@valid_attrs)
    #     |> UserContext.create_user()

    #   user
    # end

    # test "list_users/0 returns all users" do
    #   user = user_fixture()
    #   assert UserContext.list_users() == [user]
    # end

    # test "get_user!/1 returns the user with given id" do
    #   user = user_fixture()
    #   assert UserContext.get_user!(user.id) == user
    # end

    # test "create_user/1 with valid data creates a user" do
    #   assert {:ok, %User{} = user} = UserContext.create_user(@valid_attrs)
    #   assert user.dormitory == "some dormitory"
    #   assert user.email == "some email"
    #   assert user.name == "some name"
    #   assert user.phone == "some phone"
    #   assert user.room == "some room"
    #   assert user.surname == "some surname"
    #   assert user.tenant_id == 42
    # end

    # test "create_user/1 with invalid data returns error changeset" do
    #   assert {:error, %Ecto.Changeset{}} = UserContext.create_user(@invalid_attrs)
    # end

    # test "update_user/2 with valid data updates the user" do
    #   user = user_fixture()
    #   assert {:ok, user} = UserContext.update_user(user, @update_attrs)
    #   assert %User{} = user
    #   assert user.dormitory == "some updated dormitory"
    #   assert user.email == "some updated email"
    #   assert user.name == "some updated name"
    #   assert user.phone == "some updated phone"
    #   assert user.room == "some updated room"
    #   assert user.surname == "some updated surname"
    #   assert user.tenant_id == 43
    # end

    # test "update_user/2 with invalid data returns error changeset" do
    #   user = user_fixture()
    #   assert {:error, %Ecto.Changeset{}} = UserContext.update_user(user, @invalid_attrs)
    #   assert user == UserContext.get_user!(user.id)
    # end

    # test "delete_user/1 deletes the user" do
    #   user = user_fixture()
    #   assert {:ok, %User{}} = UserContext.delete_user(user)
    #   assert_raise Ecto.NoResultsError, fn -> UserContext.get_user!(user.id) end
    # end

    # test "change_user/1 returns a user changeset" do
    #   user = user_fixture()
    #   assert %Ecto.Changeset{} = UserContext.change_user(user)
    # end

    # test "check token results" do
    #   import Msmarket.DSNETImporter
    #   token = "MjhkNjRmZTYwMTZlMDJmYTNkYjZkOTY2NzRiZjI4MjFhN2M5ODdiZTYzZWFiNWZiYzIxZTcyMmViYjdmZDM2Zg"
    #   get_user_data(:user_info, token: token) |> IO.inspect
    #   get_user_data(:personal_info, token: token) |> IO.inspect
    #   get_user_data(:accommodation, token: token) |> IO.inspect
    # end
  end
end
