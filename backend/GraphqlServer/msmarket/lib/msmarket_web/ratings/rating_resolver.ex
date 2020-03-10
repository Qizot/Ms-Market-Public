defmodule MsmarketWeb.Schema.RatingResolver do
  import Absinthe.Resolution.Helpers
  alias Msmarket.RatingContext
  alias Msmarket.ItemContext.Item
  alias Msmarket.RatingContext.Rating
  alias Msmarket.RatingContext
  import MsmarketWeb.Helpers

  def get_item_ratings(_parent, %{item_id: id}, context) do
    with_role :user, context do
      {:ok, RatingContext.get_item_ratings(item_id: id)}
    end
  end

  def get_rating(_parent, %{id: id}, %{context: %{loader: loader}} = context) do
    with_role :user, context do
      loader
      |> Dataloader.load(:data, Rating, id)
      |> on_load(fn loader ->
        {:ok, Dataloader.get(loader, :data, Rating, id)}
      end)
    end
  end

  def get_item_summary(_parent, %{item_id: id}, context) do
    with_role :user, context do
      {:ok, RatingContext.get_item_summary(item_id: id)}
    end
  end

  def get_item_summary(%Item{id: id}, _args, context) do
    with_role :user, context do
      {:ok, RatingContext.get_item_summary(item_id: id)}
    end
  end

end
