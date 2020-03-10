defmodule MsmarketWeb.Auth do

  # alias Msmarket.UserContext.User

  def user(%{context: %{current_user: current_user}}) do
    current_user
  end

  def is_active_user(%{context: %{current_user: _current_user}}), do: true
  def is_active_user(_), do: false

  def has_role(:user, %{context: %{current_user: _current_user}}) do
    true
  end

  def has_role(:admin, %{context: %{roles: roles}}) do
    Enum.member?(roles, :admin)
  end

  def has_role(_, _), do: false


  def error do
    {:error, "unauthorized"}
  end

end
