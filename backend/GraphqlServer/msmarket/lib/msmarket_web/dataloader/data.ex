defmodule MsmarketWeb.Dataloader.Data do

  import Ecto.Query, warn: false
  alias Msmarket.BorrowRequestContext.BorrowRequest
  alias Msmarket.Repo


  def data() do
    Dataloader.Ecto.new(Repo, query: &query/2)
  end

  def query(BorrowRequest, %{filter: filter}) do
    BorrowRequest
    |> apply_limit(filter)
    |> order_borrow_requests_if_limit(filter)
    |> apply_borrow_statuses(filter)
  end

  def query(queryable, _params) do
    queryable
  end


  defp apply_limit(queryable, %{limit: limit}) do
    queryable |> limit(^limit)
  end

  defp apply_limit(querable, _), do: querable

  defp apply_borrow_statuses(querable, %{statuses: statuses}) do
    querable |> where([br], br.status in ^statuses)
  end

  defp apply_borrow_statuses(querable, _), do: querable

  defp order_borrow_requests_if_limit(querable, %{limit: _limit}) do
    querable |> order_by([br], desc: br.updated_at)
  end

  defp order_borrow_requests_if_limit(querable, _), do: querable





end
