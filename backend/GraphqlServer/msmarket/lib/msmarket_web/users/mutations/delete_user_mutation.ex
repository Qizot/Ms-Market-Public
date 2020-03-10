defmodule MsmarketWeb.Schema.DeleteUserMutation do
  alias Msmarket.UserContext
  alias MsmarketWeb.Helpers
  import MsmarketWeb.Helpers
  alias MsmarketWeb.Auth

  defp delete_current_user(context) do
    current_id = Auth.user(context).id
    current_user = UserContext.get_user!(current_id)
    case UserContext.delete_user(current_user) do
      {:ok, user} -> {:ok, %{deleted_user_id: user.id}}
      error -> Helpers.changeset_error(error)
    end
  end

  defp delete_user_as_admin(context, user_id) do
    with_role :admin, context do
      case UserContext.get_user(user_id) do
        nil -> {:error, "user has not been found"}
        user ->
          case UserContext.delete_user(user) do
            {:ok, user} -> {:ok, %{deleted_user_id: user.id}}
            error -> Helpers.changeset_error(error)
          end
      end
    end
  end

  def resolve(_parent, args, context) do
    with_role :user, context do
      with delete_me <- args[:delete_myself], user_id <- args[:user_id] do
        cond do
          !is_nil(delete_me) and delete_me and is_nil(user_id) -> {:error, "delete_myself flag cannot be set with user_id"}
          is_nil(delete_me) and is_nil(user_id) -> {:error, "either delete_myself flag or user_id must be set"}
          !is_nil(delete_me) && delete_me -> delete_current_user(context)
          !is_nil(user_id) -> delete_user_as_admin(context, user_id)
          true -> {:error, "no action recognized"}
        end
      end
    end
  end
end
