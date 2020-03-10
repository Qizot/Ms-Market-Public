defmodule MsmarketWeb.Schema.BorrowRequestType do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Msmarket.BorrowRequestContext.BorrowRequest
  alias MsmarketWeb.Schema.BorrowRequestResolver
  alias MsmarketWeb.Schema.CreateBorrowRequestMutation
  alias MsmarketWeb.Schema.UpdateBorrowRequestMutation

  enum :borrow_status do
    value :created, as: "CREATED"
    value :canceled, as: "CANCELED"
    value :accepted, as: "ACCEPTED"
    value :borrowed, as: "BORROWED"
    value :returned, as: "RETURNED"
    value :declined, as: "DECLINED"
  end

  object :borrow_request do
    field :id, non_null(:id)
    field :user_id, non_null(:id)
    field :item_id, non_null(:id)
    field :status, non_null(:borrow_status)
    field :updated_status_at, non_null(:naive_datetime) do
      resolve fn (%BorrowRequest{updated_at: updated_at}, _args, _context) ->
        {:ok, updated_at}
      end
    end
    field :created_at, non_null(:naive_datetime) do
      resolve fn (%BorrowRequest{inserted_at: inserted_at}, _args, _context) ->
        {:ok, inserted_at}
      end
    end
    field :item, non_null(:item) do
      resolve dataloader(:data)
    end
    field :user, non_null(:user) do
      resolve dataloader(:data)
    end
  end

  object :borrow_request_queries do

    @desc "returns current user's borrow requests comming from other users"
    field :incoming_borrow_requests, non_null(list_of(non_null(:borrow_request))) do
      arg :statuses, non_null(list_of(non_null(:borrow_status)))
      arg :limit, non_null(:integer)
      resolve &BorrowRequestResolver.get_incoming_borrow_requests/3
    end

    field :user_borrow_requests, non_null(list_of(non_null(:borrow_request))) do
      arg :user_id, non_null(:id)
      resolve &BorrowRequestResolver.get_borrow_requests/3
    end

    field :borrow_request, type: :borrow_request do
      arg :id, non_null(:id)
      resolve &BorrowRequestResolver.get_borrow_request/3
    end

    field :item_borrow_requests, non_null(list_of(non_null(:borrow_request))) do
      arg :item_id, non_null(:id)
      resolve &BorrowRequestResolver.get_borrow_requests/3
    end
  end

  object :borrow_request_mutations do
    field :create_borrow_request, type: :borrow_request do
      arg :item_id, non_null(:id)
      resolve &CreateBorrowRequestMutation.resolve/3
    end
    field :update_borrow_request, type: :borrow_request do
      arg :borrow_request_id, non_null(:id)
      arg :status, non_null(:borrow_status)
      resolve &UpdateBorrowRequestMutation.resolve/3
    end
  end
end
