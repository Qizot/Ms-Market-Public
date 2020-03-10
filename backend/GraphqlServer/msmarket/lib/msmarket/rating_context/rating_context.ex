defmodule Msmarket.RatingContext do
  @moduledoc """
  The RatingContext context.
  """

  import Ecto.Query, warn: false
  alias Msmarket.Repo

  alias Msmarket.RatingContext.Rating
  alias Msmarket.ItemContext.Item
  alias Msmarket.UserContext.User


  def list_ratings do
    Repo.all(Rating)
  end

  def get_item_ratings(item_id: id) do
    Repo.all(from r in Rating, where: r.item_id == ^id)
  end

  def get_item_summary(item_id: id) do
    default = Enum.map(1..5, fn i -> %{value: i, count: 0} end)
    counted = Repo.all(from r in Rating, where: r.item_id == ^id, group_by: r.value, select: [r.value, count(r.id)])
    |> Enum.map(
      fn [value, count | _] ->
        Map.new
        |> Map.put(:value, value)
        |> Map.put(:count, count)
    end)
    |> Kernel.++(default)
    |> MapSet.new
    |> MapSet.to_list
    {sum, count} = Enum.reduce(counted, {0, 0}, fn %{value: value, count: count}, {s, c} -> {s + value * count, c + count} end)
    average = if count == 0 do 0 else sum / count end
    %{item_id: id, counts: counted, average: average, count: count}
  end

  def get_recent_reviews(user_id: user_id, limit: limit) do
    reviews = Repo.all(
      from r in Rating,
      join: it in Item, on: r.item_id == it.id,
      join: u in User, on: it.owner_id == u.id,
      where: u.id == ^user_id,
      order_by: [desc: r.inserted_at],
      limit: ^limit,
      select: %{id: r.id, item_id: it.id}
    )
    reviews
  end


  def get_rating!(id), do: Repo.get!(Rating, id)
  def get_rating(id), do: Repo.get(Rating, id)


  def create_rating(attrs \\ %{}) do
    %Rating{}
    |> Rating.changeset(attrs)
    |> Repo.insert()
  end

  def update_rating(%Rating{} = rating, attrs) do
    rating
    |> Rating.changeset(attrs)
    |> Repo.update()
  end

  def delete_rating(%Rating{} = rating) do
    Repo.delete(rating)
  end

  def change_rating(%Rating{} = rating) do
    Rating.changeset(rating, %{})
  end
end
