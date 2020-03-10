defmodule Msmarket.BorrowRequestContext.BorrowRequest do
  use Msmarket.Schema
  import Ecto.Changeset

  alias Msmarket.UserContext.User
  alias Msmarket.ItemContext.Item

  schema "borrow_requests" do
    field :status, :string
    belongs_to :user, User
    belongs_to :item, Item

    timestamps()
  end

  @doc false
  def changeset(borrow_request, attrs) do
    borrow_request
    |> cast(attrs, [:user_id, :item_id, :status])
    |> validate_required([:user_id, :item_id, :status])
    |> validate_inclusion(:status, ["CREATED", "CANCELED", "ACCEPTED", "BORROWED", "RETURNED", "DECLINED"])
  end
end
