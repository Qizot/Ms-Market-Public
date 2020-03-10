defmodule MsmarketWeb.Schema.DeleteRatingMutation do
  alias Msmarket.RatingContext
  alias MsmarketWeb.Auth
  alias MsmarketWeb.Helpers
  import MsmarketWeb.Helpers

  def resolve(_parent, %{rating_id: rating_id}, context) do
    with_role :user, context do
      with rating when not is_nil(rating) <- RatingContext.get_rating(rating_id) do
        if rating.user_id == Auth.user(context).id or Auth.has_role(:admin, context) do
          case RatingContext.delete_rating(rating) do
            {:ok, result} -> {:ok, result}
            error -> Helpers.changeset_error(error)
          end
        else
          Auth.error()
        end
      else
        nil -> {:error, "rating has not been found"}
      end
    end
  end

end
