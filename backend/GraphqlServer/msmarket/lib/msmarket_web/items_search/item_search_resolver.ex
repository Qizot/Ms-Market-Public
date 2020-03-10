defmodule MsmarketWeb.Schema.ItemSearchResolver do
  alias Msmarket.ItemContext
  import MsmarketWeb.Helpers

  def search_items(_parent, %{query: _, dormitories: _} = params, context) do
    with_role :user, context do
      results = ItemContext.search_items(params)
      |> Enum.group_by(fn %{dormitory: dormitory} -> dormitory end)
      |> Enum.map(fn {dormitory, results} ->
        %{dormitory: dormitory, results: results}
      end)
      {:ok, results}
    end
  end

  def search_items(_parent, params, context) do
    with_role :user, context do
      results = ItemContext.search_items(params)
      {:ok, results}
    end
  end
end
