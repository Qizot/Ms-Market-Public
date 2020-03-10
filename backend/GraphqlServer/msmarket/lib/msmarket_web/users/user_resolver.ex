defmodule MsmarketWeb.Schema.UserResolver do
  alias Msmarket.UserContext
  import MsmarketWeb.Helpers

  def get_users(_parent, _args, context) do
    with_role :user, context do
      {:ok, UserContext.list_users}
    end
  end

  def get_user(_parent, %{id: id}, context) do
    with_role :user, context do
      {:ok, UserContext.get_user(id)}
    end
  end

  def get_me(_parent, _args, context) do
    with_role :user, context do
      {:ok, UserContext.get_user(context.context.current_user.id)}
    end
  end

end
