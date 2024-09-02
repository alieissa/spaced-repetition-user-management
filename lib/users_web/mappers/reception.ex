defmodule UsersWeb.Mappers.Reception do
  def to_app_request(conn) do
    path = conn.request_path
    method = String.to_atom(String.downcase(conn.method))
    headers = conn.req_headers
    params = conn.query_params
    body = conn.body_params

    %HTTPoison.Request{
      url: path,
      method: method,
      headers: headers,
      params: params,
      body: body
    }
  end
end
