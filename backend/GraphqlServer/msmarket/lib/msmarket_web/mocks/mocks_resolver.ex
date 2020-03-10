defmodule MsmarketWeb.Schema.MocksResolver do
  use Absinthe.Schema.Notation

  alias Msmarket.UserContext
  alias MsmarketWeb.Guardian
  alias Msmarket.UserContext.User

  defp get_authorization_token(%User{} = user) do
    {:ok, token, _claims} = Guardian.encode_and_sign(user, %{}, [ttl: {1, :week}, token_type: "access"])
    %{token: token, token_type: "Bearer", ttl: 60 * 60 * 24 * 7}
  end

  def list_mock_users(_parent, _args, _context) do
    result = UserContext.list_mock_users()
    |> Enum.map(fn user ->
      %{user_id: user.id, token: get_authorization_token(user)}
    end)
    {:ok, result}
  end
end
