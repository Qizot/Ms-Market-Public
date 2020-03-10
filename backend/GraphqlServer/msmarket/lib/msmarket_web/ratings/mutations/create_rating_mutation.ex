defmodule MsmarketWeb.Schema.CreateRatingMutation do
  alias Msmarket.RatingContext
  alias MsmarketWeb.Auth
  alias MsmarketWeb.Helpers
  import MsmarketWeb.Helpers

  # TODO decide if admin should be able to create rating as for other user
  def resolve(_parent, args, context) do
    with_role :user, context do
      case RatingContext.create_rating(args |> Map.put(:user_id, Auth.user(context).id)) do
        {:ok, result} -> {:ok, result}
        error -> Helpers.changeset_error(error)
      end
    end
  end
end
