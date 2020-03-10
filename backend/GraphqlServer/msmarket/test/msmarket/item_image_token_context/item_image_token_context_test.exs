defmodule Msmarket.ItemImageTokenContextTest do
  use Msmarket.DataCase

  alias Msmarket.ItemImageTokenContext

  describe "item_image_tokens" do
    # alias Msmarket.ItemImageTokenContext.ItemImageToken

    # @valid_attrs %{token: "some token"}
    # @update_attrs %{token: "some updated token"}
    # @invalid_attrs %{token: nil}

    # def item_image_token_fixture(attrs \\ %{}) do
    #   {:ok, item_image_token} =
    #     attrs
    #     |> Enum.into(@valid_attrs)
    #     |> ItemImageTokenContext.create_item_image_token()
    #   {:ok, item} = ItemContext.create_item(%{
    #     name:
    #   })
    #   item_image_token
    # end

    # test "list_item_image_tokens/0 returns all item_image_tokens" do
    #   item_image_token = item_image_token_fixture()
    #   assert ItemImageTokenContext.list_item_image_tokens() == [item_image_token]
    # end

    # test "get_item_image_token!/1 returns the item_image_token with given id" do
    #   item_image_token = item_image_token_fixture()
    #   assert ItemImageTokenContext.get_item_image_token!(item_image_token.id) == item_image_token
    # end

    # test "create_item_image_token/1 with valid data creates a item_image_token" do
    #   assert {:ok, %ItemImageToken{} = item_image_token} = ItemImageTokenContext.create_item_image_token(@valid_attrs)
    #   assert item_image_token.token == "some token"
    # end

    # test "create_item_image_token/1 with invalid data returns error changeset" do
    #   assert {:error, %Ecto.Changeset{}} = ItemImageTokenContext.create_item_image_token(@invalid_attrs)
    # end

    # test "update_item_image_token/2 with valid data updates the item_image_token" do
    #   item_image_token = item_image_token_fixture()
    #   assert {:ok, item_image_token} = ItemImageTokenContext.update_item_image_token(item_image_token, @update_attrs)
    #   assert %ItemImageToken{} = item_image_token
    #   assert item_image_token.token == "some updated token"
    # end

    # test "update_item_image_token/2 with invalid data returns error changeset" do
    #   item_image_token = item_image_token_fixture()
    #   assert {:error, %Ecto.Changeset{}} = ItemImageTokenContext.update_item_image_token(item_image_token, @invalid_attrs)
    #   assert item_image_token == ItemImageTokenContext.get_item_image_token!(item_image_token.id)
    # end

    # test "delete_item_image_token/1 deletes the item_image_token" do
    #   item_image_token = item_image_token_fixture()
    #   assert {:ok, %ItemImageToken{}} = ItemImageTokenContext.delete_item_image_token(item_image_token)
    #   assert_raise Ecto.NoResultsError, fn -> ItemImageTokenContext.get_item_image_token!(item_image_token.id) end
    # end

    # test "change_item_image_token/1 returns a item_image_token changeset" do
    #   item_image_token = item_image_token_fixture()
    #   assert %Ecto.Changeset{} = ItemImageTokenContext.change_item_image_token(item_image_token)
    # end
  end
end
