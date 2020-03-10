defmodule MsmarketWeb.Schema.Mocks do
  use Absinthe.Schema.Notation
  alias MsmarketWeb.Schema.CreateMockUserMutation
  alias MsmarketWeb.Schema.MocksResolver
  alias Msmarket.UserContext

  object :mock_user do
    field :token, non_null(:authorization_token)
    field :user, non_null(:user) do
      resolve fn (%{user_id: user_id}, _args, _context) ->
        {:ok, UserContext.get_user(user_id)}
      end
    end
  end

  object :mocks_queries do
    field :all_mock_users, non_null(list_of(non_null(:mock_user))) do
      resolve &MocksResolver.list_mock_users/3
    end
  end

  object :mocks_mutations do
    field :create_mock_user, non_null(:authorization_token) do
      arg :name, non_null(:string)
      arg :surname, non_null(:string)
      arg :phone, non_null(:string)
      arg :dormitory, non_null(:string)
      arg :room, non_null(:string)
      arg :tenant_id, non_null(:integer)
      resolve &CreateMockUserMutation.resolve/3
    end
  end


end
