defmodule MsmarketWeb.Schema.CreateItemMutation do
  alias Msmarket.ItemContext
  alias MsmarketWeb.Auth
  import MsmarketWeb.Helpers
  alias MsmarketWeb.Helpers

  def resolve(_parent, args, context) do
    with_role :user, context do
      if args.owner_id == Auth.user(context).id or Auth.has_role(:admin, context) do
        case ItemContext.create_item(args) do
          {:ok, item} -> {:ok, item}
          error -> Helpers.changeset_error(error)
        end
      else
        Auth.error()
      end
    end
  end

end
