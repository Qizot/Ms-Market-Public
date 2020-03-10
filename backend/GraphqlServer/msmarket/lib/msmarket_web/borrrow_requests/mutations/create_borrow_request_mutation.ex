defmodule MsmarketWeb.Schema.CreateBorrowRequestMutation do
  alias Msmarket.ItemContext
  alias Msmarket.BorrowRequestContext
  alias MsmarketWeb.Auth
  alias MsmarketWeb.Helpers
  import MsmarketWeb.Helpers

  def resolve(_parent, %{item_id: item_id}, context) do
    with_role :user, context do
      with item when not is_nil(item) <- ItemContext.get_item(item_id) do
        data = %{
          user_id: Auth.user(context).id,
          item_id: item_id,
          status: "CREATED"
        }
        case BorrowRequestContext.create_borrow_request(data) do
          {:ok, result} -> {:ok, result}
          error -> Helpers.changeset_error(error)
        end
      else
        nil -> {:error, "item has not been found"}
      end
    end
  end
end
