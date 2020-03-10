defmodule Msmarket.ItemContext.Item do
  use Msmarket.Schema
  import Ecto.Changeset
  alias Msmarket.UserContext.User
  alias Msmarket.RatingContext.Rating
  alias Msmarket.BorrowRequestContext.BorrowRequest
  alias Msmarket.ItemImageTokenContext.ItemImageToken

  schema "items" do
    field :name, :string
    field :description, :string
    field :image_url, :string
    field :item_category, :string
    field :contract_category, :string
    field :expires_at, :naive_datetime

    belongs_to :owner, User
    has_many :ratings, Rating
    has_many :borrow_requests, BorrowRequest
    has_one :image_token, ItemImageToken
    timestamps()
  end



  def validate_expiration_date(changeset, attrs) do
    if not is_nil(attrs[:expires_at]) do
      with {:ok, expires_at, offset}  <- DateTime.from_iso8601(attrs[:expires_at]) do
        case DateTime.compare(DateTime.utc_now, expires_at) do
          :gt -> add_error(changeset, :expires_at, "expiration date cannot be in the past")
          _ -> changeset
        end
      else
        _ -> add_error(changeset, :expires_at, "invalid datetime format")
      end
    else
      changeset
    end

  end


  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:owner_id, :name, :description, :image_url, :item_category, :contract_category, :expires_at])
    |> validate_required([:owner_id, :name, :description, :item_category, :contract_category])
    |> unique_constraint(:name, name: :items_owner_id_name_index, message: "user can't have two items with same name")
    |> validate_inclusion(:item_category, ["KITCHEN", "ELECTRONICS", "FOOD", "OTHER"])
    |> validate_inclusion(:contract_category, ["BORROW", "LEND", "TRADE", "SELL", "OTHER"])
    |> validate_expiration_date(attrs)
  end
end
