defmodule MsmarketWeb.Schema.CreateMockUserMutation do
  alias MsmarketWeb.Helpers

  alias Msmarket.UserContext
  alias MsmarketWeb.Guardian
  alias Msmarket.UserContext.User

  defp get_authorization_token(%User{} = user) do
    {:ok, token, _claims} = Guardian.encode_and_sign(user, %{}, [ttl: {1, :week}, token_type: "access"])
    %{token: token, token_type: "Bearer", ttl: 60 * 60 * 24 * 7}
  end

  def resolve(_parent, args, _context) do
    name = args[:name]
    surname = args[:surname]
    email = name <> "_" <> surname <> "@mock.com"
    args = Map.put(args, :email, email)
    case UserContext.create_user(args) do
      {:ok, user} -> {:ok, get_authorization_token(user)}
      error -> Helpers.changeset_error(error)
    end
  end
end
