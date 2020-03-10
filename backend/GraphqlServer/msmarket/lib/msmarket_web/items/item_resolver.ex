defmodule MsmarketWeb.Schema.ItemResolver do
  alias Msmarket.ItemContext
  import MsmarketWeb.Helpers
  alias Msmarket.ItemContext.Item
  import Absinthe.Resolution.Helpers

  def get_items(_parent, args, context) do
    with_role :user, context do
      {:ok, ItemContext.list_items(args)}
    end
  end

  def get_item(_parent, %{id: id}, %{context: %{loader: loader}} = context) do
    with_role :user, context do
      loader
      |> Dataloader.load(:data, Item, id)
      |> on_load(fn loader ->
        {:ok, Dataloader.get(loader, :data, Item, id)}
      end)
    end
  end

end
