defmodule Msmarket.DSNETImporter do
  @base_url "https://panel.dsnet.agh.edu.pl/api/beta"
  @user_info "/tenant/user"
  @personal_info "/tenant/personal"
  @accommodation "/tenant/accommodation"

  @token_endpoint "https://panel.dsnet.agh.edu.pl/oauth/v2/token"

  defp user_info_url do
    @base_url <> @user_info
  end

  defp personal_info_url do
    @base_url <> @personal_info
  end

  defp accommodation_url do
    @base_url <> @accommodation
  end

  defp apply_token(url, token) when is_binary(token) do
    url <> "?access_token=#{token}"
  end

  defp get(url) do
    case HTTPoison.get(url) do
      {:ok, %{status_code: 200, body: body}} ->
        Poison.decode!(body)
      {:ok, %{status_code: 400, body: body}} ->
        get_dsnet_error(body)
      {:ok, %{status_code: 404}} ->
        {:error, "DSNET url path not found"}

      {:ok, %{status_code: 401}} ->
        {:error, "DSNET Unauthorized"}

      {:error, %{reason: reason}} ->
        {:error, reason}
    end
  end

  defp get_dsnet_error(body) do
    %{"error" => error, "error_description" => description} = Poison.decode!(body)
    {:error, error <> ": " <> description}
  end

  def get_user_data(:user_info, token: token) do
    get(user_info_url() |> apply_token(token))
  end

  def get_user_data(:personal_info, token: token) do
    get(personal_info_url() |> apply_token(token))
  end

  def get_user_data(:accommodation, token: token) do
    get(accommodation_url() |> apply_token(token))
  end

  def access_dsnet_token(code: code) do
    client_id = Application.get_env(:msmarket, :dsnet)[:client_id]
    client_secret = Application.get_env(:msmarket, :dsnet)[:client_secret]
    redirect_uri = Application.get_env(:msmarket, :dsnet)[:redirect_uri]
    url = @token_endpoint <> "?code=#{code}&grant_type=authorization_code&client_id=#{client_id}&client_secret=#{client_secret}&redirect_uri=#{redirect_uri}"

    case get(url) do
      {:error, reason} -> {:error, reason}
      %{"access_token" => token} -> {:ok, token}
    end
  end

end
