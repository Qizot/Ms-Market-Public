defmodule MsmarketWeb.Schema.UpdateItemMutation do
  alias Msmarket.ItemContext
  alias MsmarketWeb.Auth
  alias MsmarketWeb.Helpers
  import MsmarketWeb.Helpers


  def resolve(_parent, args, context) do
    with_role :user, context do
      with {:ok, item} when not is_nil(item) <- {:ok, ItemContext.get_item(args[:id])} do
        with_role :user, context do
          if item.owner_id == Auth.user(context).id or Auth.has_role(:admin, context) do
            case ItemContext.update_item(item, args) do
              {:ok, item} -> {:ok, item}
              error -> Helpers.changeset_error(error)
            end
          else
            Auth.error()
          end
        end
      else
        {:ok, nil} -> {:error, "item not found"}
      end
    end
  end
end
