defmodule MsmarketWeb.Schema.UpdateBorrowRequestMutation do
  alias Msmarket.BorrowRequestContext
  alias Msmarket.ItemContext
  alias MsmarketWeb.Auth
  import MsmarketWeb.Helpers

  def handle_created(context, _item_owner_id, borrow_request) do
    cond do
      Auth.has_role(:admin, context) -> BorrowRequestContext.update_borrow_request(borrow_request, %{status: "CREATED"})
      true -> {:error, "it is not allowed to change request status to created"}
    end
  end

  def handle_canceld(context, _item_owner_id, borrow_request) do
    cond do
      Auth.has_role(:admin, context) -> BorrowRequestContext.update_borrow_request(borrow_request, %{status: "CANCELED"})
      Auth.user(context).id != borrow_request.user_id -> {:error, "only requester can cancel borrow request"}
      borrow_request.status != "CREATED" -> {:error, "requester can only cancel  request with CREATED status"}
      true -> BorrowRequestContext.update_borrow_request(borrow_request, %{status: "CANCELED"})
    end
  end

  def handle_accepted(context, item_owner_id, borrow_request) do
    cond do
      Auth.has_role(:admin, context) -> BorrowRequestContext.update_borrow_request(borrow_request, %{status: "ACCEPTED"})
      Auth.user(context).id != item_owner_id -> {:error, "only item owner can accept borrow request"}
      borrow_request.status != "CREATED" -> {:error, "owner can change status to accepted only from CREATED status"}
      true -> BorrowRequestContext.update_borrow_request(borrow_request, %{status: "ACCEPTED"})
    end
  end

  def handle_borrowed(context, _item_owner_id, borrow_request) do
    cond do
      Auth.has_role(:admin, context) -> BorrowRequestContext.update_borrow_request(borrow_request, %{status: "BORROWED"})
      Auth.user(context).id != borrow_request.user_id -> {:error, "only requester can mark item as borrowed"}
      borrow_request.status != "ACCEPTED" -> {:error, "onyl accepted request can be set to borrowed"}
      true -> BorrowRequestContext.update_borrow_request(borrow_request, %{status: "BORROWED"})
    end
  end

  def handle_returned(context, _item_owner_id, borrow_request) do
    cond do
      Auth.has_role(:admin, context) -> BorrowRequestContext.update_borrow_request(borrow_request, %{status: "RETURNED"})
      Auth.user(context).id != borrow_request.user_id -> {:error, "only requester can mark item as returned"}
      borrow_request.status != "BORROWED" -> {:error, "onyl borrowed item can be returned"}
      true -> BorrowRequestContext.update_borrow_request(borrow_request, %{status: "RETURNED"})
    end
  end

  def handle_declined(context, item_owner_id, borrow_request) do
    cond do
      Auth.has_role(:admin, context) -> BorrowRequestContext.update_borrow_request(borrow_request, %{status: "DECLINED"})
      Auth.user(context).id != item_owner_id -> {:error, "only item owner can decline request"}
      borrow_request.status not in ["CREATED", "ACCEPTED"] -> {:error, "only creared or accepted status can be changed to declined"}
      true -> BorrowRequestContext.update_borrow_request(borrow_request, %{status: "DECLINED"})
    end
  end

  def update_borrow_request(context, item_owner_id, status, borrow_request) do
    case status do
      "CREATED" -> handle_created(context, item_owner_id, borrow_request)
      "CANCELED" -> handle_canceld(context, item_owner_id, borrow_request)
      "ACCEPTED" -> handle_accepted(context, item_owner_id, borrow_request)
      "BORROWED" -> handle_borrowed(context, item_owner_id, borrow_request)
      "RETURNED" -> handle_returned(context, item_owner_id, borrow_request)
      "DECLINED" -> handle_declined(context, item_owner_id, borrow_request)
      value -> {:error, "unknown status #{value}"}
    end
  end

  def resolve(_parent, %{borrow_request_id: borrow_request_id, status: status}, context) do
    with_role :user, context do
      with br when not is_nil(br) <- BorrowRequestContext.get_borrow_request(borrow_request_id) do
        item = ItemContext.get_item(br.item_id)
        update_borrow_request(context, item.owner_id, status, br)
      else
        nil -> {:error, "borrow request has not been found"}
      end
    end
  end
end
