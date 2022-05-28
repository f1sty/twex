defmodule Twex do
  @moduledoc """
  Documentation for `Twex`.
  """

  alias Twex.Http

  @twitter Application.compile_env(:twex, Twitter)

  def search_tweets(query) do
    query = [query: query, expansions: "author_id"] |> URI.encode_query()

    headers = [{'Authorization', "Bearer " <> bearer_token()}]

    {:ok, response} =
      "2/tweets/search/recent"
      |> endpoint()
      |> URI.new!()
      |> URI.append_query(query)
      |> to_string()
      |> Http.get(headers)

    Jason.decode!(response)
  end

  def rate_limit_status() do
    headers = [{'Authorization', "Bearer " <> bearer_token()}]

    "1.1/application/rate_limit_status"
    |> endpoint()
    |> Http.get(headers)
  end

  @spec bearer_token() :: String.t()
  defp bearer_token() do
    case @twitter[:bearer_token] do
      nil ->
        key = key()

        {:ok, response} =
          Http.post(
            endpoint("oauth2/token"),
            "grant_type=client_credentials",
            "application/x-www-form-urlencoded;charset=UTF-8",
            [{'Authorization', "Basic " <> key}]
          )

        response
        |> Jason.decode!()
        |> Map.get("access_token")

      bearer_token ->
        bearer_token
    end
  end

  defp key() do
    consumer_key = @twitter[:api_key] |> URI.encode()
    consumer_secret = @twitter[:api_key_secret] |> URI.encode()

    Base.encode64(consumer_key <> ":" <> consumer_secret)
  end

  defp endpoint(path) do
    @twitter[:base_url] <> path
  end
end
