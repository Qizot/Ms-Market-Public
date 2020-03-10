defmodule Msmarket.RatingContext.Rating do
  use Msmarket.Schema
  import Ecto.Changeset
  alias Msmarket.UserContext.User
  alias Msmarket.ItemContext.Item

  schema "ratings" do
    field :description, :string
    field :value, :integer
    belongs_to :user, User
    belongs_to :item, Item

    timestamps()
  end

  @doc false
  def changeset(rating, attrs) do
    rating
    |> cast(attrs, [:item_id, :user_id, :description, :value])
    |> validate_required([:item_id, :user_id, :value])
    |> unique_constraint(:user_id, name: :ratings_item_id_user_id_index, message: "user can rate given item only once")
    |> validate_inclusion(:value, 1..5)
  end
end
