defmodule MsmarketWeb.Schema do
  use Absinthe.Schema
  alias MsmarketWeb.Dataloader.Data

  def context(ctx) do
    loader =
      Dataloader.new
      |> Dataloader.add_source(:data, Data.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end

  import_types MsmarketWeb.Schema.{
    UserType,
    AuthorizationTokenType,
    ItemType,
    RatingType,
    BorrowRequestType,
    ItemImageTokenType,
    RecentReviewType,
    ItemSearchType,
    Mocks
  }
  import_types Absinthe.Type.Custom

  query do
    import_fields :user_queries
    import_fields :item_queries
    import_fields :rating_queries
    import_fields :borrow_request_queries
    import_fields :item_image_token_queries
    import_fields :item_search_queries
    import_fields :mocks_queries
  end

  mutation do
    import_fields :user_mutations
    import_fields :authorization_token_mutations
    import_fields :item_mutations
    import_fields :rating_mutations
    import_fields :borrow_request_mutations
    import_fields :mocks_mutations
  end

end
