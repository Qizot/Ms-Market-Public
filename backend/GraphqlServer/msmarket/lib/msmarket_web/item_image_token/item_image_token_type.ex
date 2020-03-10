defmodule MsmarketWeb.Schema.ItemImageTokenType do
  use Absinthe.Schema.Notation
  alias MsmarketWeb.Schema.ItemImageTokenResolver

  object :item_image_token do
    field :id, non_null(:id)
    field :item_id, non_null(:id)
    field :token, non_null(:string)
  end

  object :item_image_token_queries do
    field :all_item_image_tokens, non_null(list_of(non_null(:item_image_token))) do
      arg :user_id, non_null(:id)
      resolve &ItemImageTokenResolver.get_item_image_tokens/3
    end

    field :item_image_token, type: :item_image_token do
      arg :id, non_null(:id)
      resolve &ItemImageTokenResolver.get_item_image_token/3
    end
  end

end
