defmodule Msmarket.ItemImageTokenContext do
  @moduledoc """
  The ItemImageTokenContext context.
  """

  import Ecto.Query, warn: false
  alias Msmarket.Repo

  alias Msmarket.ItemImageTokenContext.ItemImageToken
  alias Msmarket.ItemContext.Item

  def user_owns_token(user_id: user_id, token_id: token_id) do
    query = from t in ItemImageToken, join: i in Item, where: i.id == t.item_id and i.user_id == ^user_id and t.id == ^token_id
    Repo.aggregate(query, :count, :id) > 0
  end

  def list_item_image_tokens do
    Repo.all(ItemImageToken)
  end

  def list_item_image_tokens(filter: %{user_id: user_id}) do
    Repo.all(from t in ItemImageToken, join: i in Item, where: i.id == t.item_id and i.user_id == ^user_id)
  end

  def get_item_image_token!(id), do: Repo.get!(ItemImageToken, id)
  def get_item_image_token(id), do: Repo.get(ItemImageToken, id)

  def get_item_image_token_by_item_id(id), do: Repo.one(from t in ItemImageToken, where: t.item_id == ^id)

  def create_item_image_token(attrs \\ %{}) do
    %ItemImageToken{}
    |> ItemImageToken.changeset(attrs)
    |> Repo.insert()
  end

  def update_item_image_token(%ItemImageToken{} = item_image_token, attrs) do
    item_image_token
    |> ItemImageToken.changeset(attrs)
    |> Repo.update()
  end

  def delete_item_image_token(%ItemImageToken{} = item_image_token) do
    Repo.delete(item_image_token)
  end

  def change_item_image_token(%ItemImageToken{} = item_image_token) do
    ItemImageToken.changeset(item_image_token, %{})
  end
end
