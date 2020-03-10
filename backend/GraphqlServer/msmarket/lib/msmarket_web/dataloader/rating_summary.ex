defmodule MsmarketWeb.Dataloader.RatingSummary do

  alias Msmarket.ItemContext.Item
  alias Msmarket.Repo

  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end


  def query(queryable, _params) do
    queryable
  end

end
