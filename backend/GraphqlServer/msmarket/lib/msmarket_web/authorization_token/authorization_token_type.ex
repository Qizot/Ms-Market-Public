defmodule MsmarketWeb.Schema.AuthorizationTokenType do
  use Absinthe.Schema.Notation
  alias MsmarketWeb.Schema.CreateAuthorizationTokenMutation

  object :authorization_token do
    field :token, non_null(:string)
    field :token_type, non_null(:string)
    field :ttl, non_null(:integer)
  end

  object :authorization_token_mutations do
    field :login, type: non_null(:authorization_token) do
      arg :code, non_null(:string)
      resolve &CreateAuthorizationTokenMutation.resolve/3
    end
    # no refresh token for now as we dont store them in database
  end

end
