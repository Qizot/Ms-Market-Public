defmodule MsmarketWeb.Schema.CreateAuthorizationTokenMutation do

  alias Msmarket.UserContext
  alias MsmarketWeb.Guardian
  alias Msmarket.UserContext.User

  defp get_authorization_token(%User{} = user) do
    {:ok, token, _claims} = Guardian.encode_and_sign(user, %{}, [ttl: {1, :week}, token_type: "access"])
    %{token: token, token_type: "Bearer", ttl: 60 * 60 * 24 * 7}
  end

  def resolve(_parent, %{code: code}, _opts) do
    case UserContext.authenticate_user(code) do
      {:ok, user} -> {:ok, get_authorization_token(user)}
      {:error, reason} -> {:error, reason}
    end
  end
end
