defmodule Msmarket.ItemContext do
  @moduledoc """
  The ItemContext context.
  """

  import Ecto.Query, warn: false
  alias Ecto.UUID
  alias Ecto.Multi
  alias Msmarket.Repo
  alias Msmarket.ItemSearch

  alias Msmarket.ItemContext.Item
  alias Msmarket.UserContext.User
  alias Msmarket.ItemImageTokenContext.ItemImageToken
  alias MsmarketWeb.Helpers

  def list_items do
    Repo.all(Item)
  end



  def list_items(args) do
    item_category = args[:item_category]
    contract_category = args[:item_category]
    limit_amount = args[:limit]

    query = Item
    query = if !is_nil(item_category), do: query |> where([i], where: i.item_category == ^item_category), else: query
    query = if !is_nil(item_category), do: query |> where([i], where: i.contract_category == ^contract_category), else: query
    query = if !is_nil(limit_amount), do: query |> limit(^limit_amount), else: query
    query |> Repo.all
  end

  def get_user_items(user_id: id) do
    Repo.all(from i in Item, where: i.owner_id == ^id, order_by: [desc: :inserted_at])
  end

  def get_item!(id), do: Repo.get!(Item, id)
  def get_item(id), do: Repo.get(Item, id)

  def create_item(attrs \\ %{}) do
    item_changeset = Item.changeset(%Item{}, attrs)

    multi =
    Multi.new
    |> Multi.insert(:item, item_changeset)
    |> Multi.run(:item_image_token, fn %{item: item}->
      args = %{
        item_id: item.id,
        token: UUID.bingenerate() |> UUID.load() |> elem(1)
      }
      token_changeset = ItemImageToken.changeset(%ItemImageToken{}, args)
     case Repo.insert(token_changeset) do
      {:ok, result} -> {:ok, result}
      {:error, reason} -> {:error, reason}
     end
    end)

    case Repo.transaction(multi) do
      {:ok, %{item: item}} ->
        {:ok, item}
      {:error, _name, changeset, _data} ->
        Helpers.changeset_error({:error, changeset})
    end
  end

  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
  end

  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end

  def change_item(%Item{} = item) do
    Item.changeset(item, %{})
  end

  ##### SEARCH ZONE #####


  def search_items(%{query: query_string, limit: limit_items} = params) do
    has_dormitories = Map.has_key?(params, :dormitories)

    query_user = if has_dormitories do
      fn query ->
        query
        |> join(:inner, [item, item_rank], u in User, [id: item.owner_id])
        |> where([item, item_rank, user], user.dormitory in ^params[:dormitories])
      end
    else
      fn query -> query end
    end

    select_fields = if has_dormitories do
      fn query -> query |> select([a,b,c], %{id: a.id, score: b.rank, dormitory: c.dormitory}) end
    else
      fn query -> query |> select([a,b], %{id: a.id, score: b.rank}) end
    end

    Item
    |> ItemSearch.run(query_string)
    |> query_user.()
    |> limit(^limit_items)
    |> select_fields.()
    |> Repo.all
  end

end
