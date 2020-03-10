defmodule Msmarket.ItemImageTokenContext.ItemImageToken do
  use Msmarket.Schema
  import Ecto.Changeset
  alias Msmarket.ItemContext.Item

  schema "item_image_tokens" do
    field :token, :string
    belongs_to :item, Item
    timestamps()
  end

  @doc false
  def changeset(item_image_token, attrs) do
    item_image_token
    |> cast(attrs, [:token, :item_id])
    |> validate_required([:token, :item_id])
    |> unique_constraint(:item_id)
  end
end
