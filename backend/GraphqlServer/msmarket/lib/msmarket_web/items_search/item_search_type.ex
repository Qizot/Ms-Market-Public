defmodule MsmarketWeb.Schema.ItemSearchType do
  use Absinthe.Schema.Notation

  alias MsmarketWeb.Schema.ItemSearchResolver
  alias MsmarketWeb.Schema.ItemResolver

  object :item_search_result do
   field :score, non_null(:float)
   field :item, non_null(:item) do
    resolve fn (%{id: item_id}, _args, context) ->
      ItemResolver.get_item(%{}, %{id: item_id}, context)
    end
   end
  end

  object :dormitory_items_search_result do
    field :dormitory, non_null(:string)
    field :results, non_null(list_of(non_null(:item_search_result)))
  end

  object :item_search_queries do
    field :item_search, non_null(list_of(:item_search_result)) do
      arg :query, non_null(:string)
      arg :limit, non_null(:integer)
      resolve &ItemSearchResolver.search_items/3
    end

    field :dormitory_items_search, non_null(list_of(non_null(:dormitory_items_search_result))) do
      arg :query, non_null(:string)
      arg :limit, non_null(:integer)
      arg :dormitories, list_of(non_null(:string))
      resolve &ItemSearchResolver.search_items/3
    end

  end

end
