defmodule MsmarketWeb.Schema.BorrowRequestResolver do
  alias Msmarket.BorrowRequestContext
  alias MsmarketWeb.Auth

  import MsmarketWeb.Helpers

  def get_borrow_request(_parent, %{id: id}, context) do
    with_role :user, context do
      {:ok, BorrowRequestContext.get_borrow_request(id)}
    end
  end

  def get_borrow_requests(_parent, %{item_id: item_id}, context) do
    with_role :user, context do
      {:ok, BorrowRequestContext.get_borrow_requests(item_id: item_id)}
    end
  end

  def get_borrow_requests(_parent, %{user_id: user_id}, context) do
    with_role :user, context do
      {:ok, BorrowRequestContext.get_borrow_requests(user_id: user_id)}
    end
  end

  def get_incoming_borrow_requests(_parent, %{statuses: statuses, limit: limit}, context) do
    with_role :user, context do
      user_id = Auth.user(context).id
      {:ok, BorrowRequestContext.get_incoming_borrow_requests(user_id: user_id, limit: limit, statuses: statuses)}
    end
  end

end
