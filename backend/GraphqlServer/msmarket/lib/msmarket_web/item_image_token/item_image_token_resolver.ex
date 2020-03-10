defmodule MsmarketWeb.Schema.ItemImageTokenResolver do
  alias Msmarket.ItemContext.Item
  alias Msmarket.ItemImageTokenContext
  alias MsmarketWeb.Auth
  import MsmarketWeb.Helpers

  def find_and_authorize(context, id, find_function) do
    with iit when not is_nil(iit) <- find_function.(id) do
      if Auth.has_role(:admin, context) or ItemImageTokenContext.user_owns_token(user_id: Auth.user(context).id, token_id: iit.id) do
        {:ok, iit}
      else
        Auth.error()
      end
    else
      nil -> {:error, "item image token has not been found"}
    end
  end

  def get_item_image_token(_parent, %{id: id}, context) do
    with_role :user, context do
      find_and_authorize(context, id, &ItemImageTokenContext.get_item_image_token/1)
    end
  end

  def get_item_image_token(%Item{id: id}, _args, context) do
    with_role :user, context do
      find_and_authorize(context, id, &ItemImageTokenContext.get_item_image_token_by_item_id/1)
    end
  end

  def get_item_image_tokens(_parent, %{user_id: user_id}, context) do
    with_role :user, context do
      if Auth.has_role(:admin, context) or Auth.user(context).id == user_id do
        {:ok, ItemImageTokenContext.list_item_image_tokens(filter: %{user_id: user_id})}
      else
        Auth.error()
      end
    end
  end


end
