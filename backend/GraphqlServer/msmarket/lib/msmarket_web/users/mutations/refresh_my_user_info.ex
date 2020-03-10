defmodule MsmarketWeb.Schema.RefreshMyUserInfoMutation do
  alias Msmarket.UserContext
  import MsmarketWeb.Helpers

  def resolve(_parent, %{dsnet_token: token}, context) do
    with_role :user, context do
      UserContext.refresh_user(token: token)
    end
  end
end
