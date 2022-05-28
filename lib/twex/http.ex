defmodule Twex.Http do
  @type response :: {:ok, binary} | {:error, atom}

  @spec get(binary, list) :: response
  def get(url, headers \\ []) do
    http_options = [autoredirect: true]
    options = [body_format: :binary]

    case :httpc.request(:get, {url, headers}, http_options, options) do
      {:error, {reason, _details}} ->
        {:error, reason}

      {:ok, {{_http_version, 200, 'OK'}, _response_headers, body}} ->
        {:ok, body}

      {:ok, {{_http_version, code, _status}, _response_headers, _body}} ->
        {:error, :"#{code}"}
    end
  end

  @spec post(binary, binary, list) :: response
  def post(url, body, content_type, headers \\ []) do
    http_options = [autoredirect: true]
    options = [body_format: :binary]

    case :httpc.request(
           :post,
           {url, headers, to_charlist(content_type), body},
           http_options,
           options
         ) do
      {:error, {reason, details}} ->
        {:error, reason, details}

      {:ok, {{_http_version, 200, 'OK'}, _response_headers, body}} ->
        {:ok, body}

      {:ok, {{_http_version, code, _status}, _response_headers, _body}} ->
        {:error, :"#{code}"}
    end
  end
end
