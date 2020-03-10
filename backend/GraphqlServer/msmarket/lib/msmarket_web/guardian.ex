defmodule MsmarketWeb.Guardian do
  use Guardian, otp_app: :msmarket
  alias Msmarket.UserContext

  def subject_for_token(resource, _claims), do: {:ok, to_string(resource.id)}
  def resource_from_claims(claims) do
    with {:ok, user} when not is_nil(user) <- {:ok, UserContext.get_user(claims["sub"])} do
      {:ok, user}
    else
      {:ok, nil} -> {:error, "user has no been found"}
    end
  end
end
