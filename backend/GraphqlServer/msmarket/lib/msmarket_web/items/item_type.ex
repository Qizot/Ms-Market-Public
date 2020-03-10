defmodule MsmarketWeb.Schema.ItemType do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Msmarket.ItemContext.Item
  alias MsmarketWeb.Schema.ItemResolver
  alias MsmarketWeb.Schema.CreateItemMutation
  alias MsmarketWeb.Schema.DeleteItemMutation
  alias MsmarketWeb.Schema.UpdateItemMutation

  import MsmarketWeb.Schema.RatingType
  import MsmarketWeb.Schema.ItemImageTokenType


  enum :item_category do
    value :kitchen,  as: "KITCHEN"
    value :electronics, as: "ELECTRONICS"
    value :food,  as: "FOOD"
    value :other, as: "OTHER"
  end

  enum :contract_category do
    value :borrow,  as: "BORROW"
    value :lend, as: "LEND"
    value :trade,  as: "TRADE"
    value :sell, as: "SELL"
    value :other, as: "OTHER"
  end


  object :item do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :description, non_null(:string)
    field :item_category, non_null(:item_category)
    field :contract_category, non_null(:contract_category)
    field :owner_id, non_null(:id)
    field :expires_at, :string
    field :created_at, non_null(:string) do
      resolve fn (%Item{inserted_at: inserted_at}, _args, _context) ->
        {:ok, inserted_at}
      end
    end

    field :owner, non_null(:user) do
      resolve dataloader(:data)
    end

    field :ratings, non_null(list_of(non_null(:rating))) do
      resolve dataloader(:data)
    end

    field :borrow_requests, type: non_null(list_of(non_null(:borrow_request))) do
      resolve dataloader(:data)
    end

    field :image_token, non_null(:item_image_token) do
      resolve dataloader(:data)
    end

    item_rating_summary()
  end

  object :item_queries do
    field :all_items, type: non_null(list_of(non_null(:item))) do
      arg :item_category, type: :item_category
      arg :contract_category, type: :contract_category
      arg :limit, :integer
      resolve &ItemResolver.get_items/3
    end

    field :item, type: :item do
      arg :id, non_null(:id)
      resolve &ItemResolver.get_item/3
    end
  end

  object :item_mutations do
    field :create_item, type: :item do
      arg :name, non_null(:string)
      arg :description, non_null(:string)
      arg :item_category, non_null(:item_category)
      arg :contract_category, non_null(:contract_category)
      arg :owner_id, non_null(:id)
      arg :expires_at, :string
      resolve &CreateItemMutation.resolve/3
    end

    field :update_item, type: :item do
      arg :id, non_null(:id)
      arg :name, :string
      arg :description, :string
      arg :item_category, :item_category
      arg :contract_category, :contract_category
      arg :expires_at, :string
      resolve &UpdateItemMutation.resolve/3
    end

    field :delete_item, :item do
      arg :item_id, non_null(:id)
      resolve &DeleteItemMutation.resolve/3
    end

  end
end
