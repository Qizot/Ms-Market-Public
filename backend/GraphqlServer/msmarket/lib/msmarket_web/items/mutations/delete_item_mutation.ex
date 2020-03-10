defmodule MsmarketWeb.Schema.DeleteItemMutation do
  alias Msmarket.ItemContext
  alias MsmarketWeb.Auth
  import MsmarketWeb.Helpers

  def resolve(_parent, %{item_id: id}, context) do
    with {:ok, item} when not is_nil(item) <- {:ok, ItemContext.get_item(id)} do
      with_role :user, context do
        if item.owner_id == Auth.user(context).id or Auth.has_role(:admin, context) do
          ItemContext.delete_item(item)
        else
          Auth.error()
        end
      end
    else
      {:ok, nil} -> {:error, "item not found"}
    end

  end
end
