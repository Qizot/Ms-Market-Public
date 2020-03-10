defmodule MsmarketWeb.Schema.RecentReviewType do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1, dataloader: 2]


  alias MsmarketWeb.Schema.ReviewResolver
  alias Msmarket.ItemContext.Item
  alias MsmarketWeb.Schema.ItemResolver
  alias MsmarketWeb.Schema.RatingResolver


  object :review do
    # id is rating's identifier
    field :id, non_null(:id)
    field :item, non_null(:item) do
      # resolve dataloader(:data, Item
      resolve fn (%{item_id: item_id}, _args, context) ->
        ItemResolver.get_item(%{}, %{id: item_id}, context)
      end
    end

    field :rating, non_null(:rating) do
      # resolve dataloader(:data)
      resolve fn (%{id: rating_id}, _args, context) ->
        RatingResolver.get_rating(%{}, %{id: rating_id}, context)
      end
    end
  end

  # object :review_queries do
  #   field :recent_reviews, non_null(list_of(non_null(:review))) do
  #     arg :limit, non_null(:integer)
  #     resolve &ReviewResolver.get_recent_reviews/3
  #   end
  # end

  defmacro recent_reviews() do
    quote do
      field :recent_reviews, non_null(list_of(non_null(:review))) do
        arg :limit, non_null(:integer)
        resolve &ReviewResolver.get_recent_reviews/3
      end
    end
  end
end
