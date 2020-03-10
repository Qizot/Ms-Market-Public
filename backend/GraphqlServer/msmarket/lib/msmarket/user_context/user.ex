defmodule Msmarket.UserContext.User do
  use Msmarket.Schema
  import Ecto.Changeset

  alias Msmarket.ItemContext.Item
  alias Msmarket.BorrowRequestContext.BorrowRequest
  alias Msmarket.RatingContext.Rating

  schema "users" do
    field :name, :string
    field :surname, :string
    field :email, :string
    field :phone, :string
    field :dormitory, :string
    field :room, :string
    field :tenant_id, :integer

    has_many :items, Item, foreign_key: :owner_id
    has_many :borrow_requests, BorrowRequest
    has_many :ratings, Rating

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :surname, :email, :dormitory, :tenant_id, :phone, :dormitory, :room])
    |> validate_required([:name, :surname, :email, :dormitory, :tenant_id, :phone, :dormitory, :room])
  end
end
