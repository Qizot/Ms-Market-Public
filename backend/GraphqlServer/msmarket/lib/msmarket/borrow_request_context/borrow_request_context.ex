defmodule Msmarket.BorrowRequestContext do
  @moduledoc """
  The BorrowRequestContext context.
  """

  import Ecto.Query, warn: false
  alias Msmarket.Repo
  import Ecto.Changeset
  alias Msmarket.UserContext.User
  alias Msmarket.ItemContext.Item

  alias Msmarket.BorrowRequestContext.BorrowRequest


  @doc """
  Returns the list of borrow_requests.

  ## Examples

      iex> list_borrow_requests()
      [%BorrowRequest{}, ...]

  """
  def list_borrow_requests do
    Repo.all(BorrowRequest)
  end

  @doc """
  Gets a single borrow_request.

  Raises `Ecto.NoResultsError` if the Borrow request does not exist.

  ## Examples

      iex> get_borrow_request!(123)
      %BorrowRequest{}

      iex> get_borrow_request!(456)
      ** (Ecto.NoResultsError)

  """
  def get_borrow_request!(id), do: Repo.get!(BorrowRequest, id)
  def get_borrow_request(id), do: Repo.get(BorrowRequest, id)

  def get_borrow_requests(item_id: item_id) do
    Repo.all(from br in BorrowRequest, where: br.item_id == ^item_id, order_by: [desc: :updated_at])
  end

  def get_borrow_requests(user_id: user_id) do
    Repo.all(from br in BorrowRequest, where: br.user_id == ^user_id, order_by: [desc: :updated_at])
  end


  def get_incoming_borrow_requests(user_id: user_id, limit: limit, statuses: statuses) do
    from(br in BorrowRequest,
      join: i in Item, on: br.item_id == i.id,
      join: u in User, on: i.owner_id == u.id,
      where: u.id == ^user_id and br.status in ^statuses,
      limit: ^limit
    )
    |> Repo.all
  end

  @doc """
  Creates a borrow_request.

  ## Examples

      iex> create_borrow_request(%{field: value})
      {:ok, %BorrowRequest{}}

      iex> create_borrow_request(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  defp check_request_uniqueness(%Ecto.Changeset{valid?: false} = cs), do: cs

  defp check_request_uniqueness(%Ecto.Changeset{valid?: true} = cs) do
    %{user_id: user_id, item_id: item_id} = cs.changes
    query = from(br in BorrowRequest, where: br.user_id == ^user_id and br.item_id == ^item_id and br.status == "CREATED")
    if Repo.aggregate(query, :count, :id) > 0 do
      add_error(cs, :status, "user has already an active request for given item")
    else
      cs
    end
  end

  defp check_status(%Ecto.Changeset{} = cs, status) do
    case cs.changes.status do
      ^status -> cs
      _ -> add_error(cs, :status, "request creation must be with #{status} status")
    end
  end

  def create_borrow_request(attrs \\ %{}) do
    %BorrowRequest{}
    |> BorrowRequest.changeset(attrs)
    |> check_status("CREATED")
    |> check_request_uniqueness
    |> Repo.insert()
  end

  @doc """
  Updates a borrow_request.

  ## Examples

      iex> update_borrow_request(borrow_request, %{field: new_value})
      {:ok, %BorrowRequest{}}

      iex> update_borrow_request(borrow_request, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_borrow_request(%BorrowRequest{} = borrow_request, attrs) do
    borrow_request
    |> BorrowRequest.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a BorrowRequest.

  ## Examples

      iex> delete_borrow_request(borrow_request)
      {:ok, %BorrowRequest{}}

      iex> delete_borrow_request(borrow_request)
      {:error, %Ecto.Changeset{}}

  """
  def delete_borrow_request(%BorrowRequest{} = borrow_request) do
    Repo.delete(borrow_request)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking borrow_request changes.

  ## Examples

      iex> change_borrow_request(borrow_request)
      %Ecto.Changeset{source: %BorrowRequest{}}

  """
  def change_borrow_request(%BorrowRequest{} = borrow_request) do
    BorrowRequest.changeset(borrow_request, %{})
  end
end
