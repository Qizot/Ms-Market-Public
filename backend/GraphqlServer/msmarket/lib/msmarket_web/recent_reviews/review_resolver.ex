defmodule MsmarketWeb.Schema.ReviewResolver do
  alias Msmarket.UserContext.User
  alias Msmarket.RatingContext
  import MsmarketWeb.Helpers

  def get_recent_reviews(%User{id: id}, %{limit: limit}, context) do
    with_role :user, context do
      {:ok, RatingContext.get_recent_reviews(user_id: id, limit: limit)}
    end
  end
end
