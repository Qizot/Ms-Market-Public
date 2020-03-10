defmodule MsmarketWeb.Context do
  @behaviour Plug

  import Plug.Conn
  alias MsmarketWeb.Guardian
  alias Msmarket.UserRoleContext

  def init(opts), do: opts

  def call(conn, _) do
    context = build_context(conn)
    Absinthe.Plug.put_options(conn, context: context)
  end

  @doc """
  Return the current user context based on the authorization header
  """
  def build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
    {:ok, current_user, roles} <- authorize(token) do
      %{
        current_user: current_user,
        roles: parse_roles(roles)
      }
    else
      _ -> %{}
    end
  end

  defp authorize(token) do
    case Guardian.resource_from_token(token) do
      {:ok, user, _} ->
        roles =  UserRoleContext.get_user_roles(user_id: user.id)
        {:ok, user, roles}
      _ -> {:error, "invalid token"}
    end
  end

  defp parse_roles(roles) do
    roles
    |> Enum.map(&(&1.role))
    |> Enum.map(& String.to_atom(&1))
  end

end
