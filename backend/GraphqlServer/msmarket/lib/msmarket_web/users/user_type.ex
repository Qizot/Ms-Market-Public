defmodule MsmarketWeb.Schema.UserType do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias Msmarket.UserContext.User
  alias MsmarketWeb.Schema.{
    UserResolver,
    DeleteUserMutation,
    RefreshMyUserInfoMutation
  }

  import MsmarketWeb.Schema.RecentReviewType

  input_object :borrow_request_filter do
    field :limit, :integer
    field :statuses, list_of(:borrow_status)
  end

  object :user do
    field :id, non_null(:id)
    field :name, non_null(:string)
    field :surname, non_null(:string)
    field :email, non_null(:string)
    field :dormitory, non_null(:string)
    field :room, non_null(:string)
    field :tenant_id, non_null(:integer)
    field :joined, non_null(:string) do
      resolve fn (%User{inserted_at: inserted_at}, _args, _context) ->
        {:ok, inserted_at}
      end
    end

    field :items, type: non_null(list_of(non_null(:item))) do
      resolve dataloader(:data)
    end

    field :borrow_requests, type: non_null(list_of(non_null(:borrow_request))) do
      arg :filter, :borrow_request_filter
      resolve dataloader(:data)
    end

    recent_reviews()
  end

  object :user_queries do
    field :all_users, type: non_null(list_of(non_null(:user))) do
      resolve &UserResolver.get_users/3
    end

    field :user, type: :user do
      arg :id, non_null(:string)
      resolve &UserResolver.get_user/3
    end
    field :me, type: :user do
      resolve &UserResolver.get_me/3
    end
  end

  object :delete_user_result do
    field :deleted_user_id, non_null(:id)
  end

  object :user_mutations do
    field :refresh_my_user_info, type: :user do
      arg :dsnet_token, non_null(:string)
      resolve &RefreshMyUserInfoMutation.resolve/3
    end

    field :delete_user, :delete_user_result do
      arg :user_id, :id
      arg :delete_myself, :boolean
      resolve &DeleteUserMutation.resolve/3
    end
  end
end
