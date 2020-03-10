defmodule MsmarketWeb.Helpers do
  alias MsmarketWeb.Auth
  # a little hack for now, we will use roles later
  # context plug is responsible for authorization, we check here only user existence in context
  defmacro with_role(role, context, [do: expr]) do
    quote do
      if (Auth.has_role(unquote(role), unquote(context))), do: unquote(expr), else: Auth.error()
    end
  end

  def changeset_error({:error, %Ecto.Changeset{valid?: false} = cs}) do
    {
      :error,
      cs
      |> Ecto.Changeset.traverse_errors(fn {err, _opts} -> err end)
      |> Enum.map(fn({k, v}) -> [message: [k, v]] end)
    }
  end

  def changeset_error(error), do: error
end
