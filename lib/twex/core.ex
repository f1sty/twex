defmodule Twex.Core do
  @type response :: {:ok, binary} | {:error, atom}

  @spec get(binary, list) :: response
  def get(url, headers \\ []) do
    http_options = [
      {:autoredirect, true}
    ]

    options = [
      {:body_format, :binary}
    ]

    case :httpc.request(:get, {url, headers}, http_options, options) do
      {:error, {reason, [{:to_address, {'f1sty.github.i', 443}}, {:inet, [:inet], :nxdomain}]}} ->
        {:error, reason}

      {:ok, {{_http_version, 200, 'OK'}, _response_headers, body}} ->
        {:ok, body}

      {:ok, {{_http_version, code, _status}, _response_headers, _body}} ->
        {:error, :"status_#{code}"}
    end
  end
end
