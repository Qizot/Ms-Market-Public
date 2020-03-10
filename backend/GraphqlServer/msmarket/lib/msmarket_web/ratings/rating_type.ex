defmodule MsmarketWeb.Schema.RatingType do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]
  alias MsmarketWeb.Schema.RatingResolver
  alias MsmarketWeb.Schema.CreateRatingMutation
  alias MsmarketWeb.Schema.UpdateRatingMutation
  alias MsmarketWeb.Schema.DeleteRatingMutation

  enum :rating_value do
    value :one, as: 1
    value :two, as: 2
    value :three, as: 3
    value :four, as: 4
    value :five, as: 5
  end

  object :rating do
    field :id, non_null(:id)
    field :item_id, non_null(:id)
    field :item, non_null(:item) do
      resolve dataloader(:data)
    end
    field :user_id, non_null(:id)
    field :user, non_null(:user) do
      resolve dataloader(:data)
    end
    field :description, :string
    field :value, non_null(:rating_value)
  end

  object :rating_count do
    description "pair (value, count) where value is rating value 1-5 and count is number of occurances"
    field :value, :integer
    field :count, :integer
  end

  object :rating_summary do
    field non_null(:item_id)
    field :counts, non_null(list_of(non_null(:rating_count)))
    field :average, non_null(:float)
    field :count, non_null(:integer)
  end

  object :rating_queries do
    field :item_ratings, non_null(list_of(non_null(:rating))) do
      arg :item_id, non_null(:id)
      resolve &RatingResolver.get_item_ratings/3
    end

    field :item_rating_summary, type: :rating_summary do
      arg :item_id, non_null(:id)
      resolve &RatingResolver.get_item_summary/3
    end
  end

  defmacro item_rating_summary() do
    quote do
      field :summary, non_null(:rating_summary) do
        resolve &RatingResolver.get_item_summary/3
      end
    end
  end

  object :rating_mutations do
    field :rate_item, :rating do
      arg :item_id, non_null(:id)
      arg :value, non_null(:rating_value)
      arg :description, :string
      resolve &CreateRatingMutation.resolve/3
    end

    field :update_item_rating, :rating do
      arg :rating_id, non_null(:id)
      arg :description, :string
      arg :value, :rating_value
      resolve &UpdateRatingMutation.resolve/3
    end

    field :delete_item_rating, :rating do
      arg :rating_id, non_null(:id)
      resolve &DeleteRatingMutation.resolve/3
    end

  end

end
