defmodule Web.V1.MainController do
  use Web, :controller

  def request(conn, params) do
    case Ztm.peka_api_request(params) do
      {:ok, %Tesla.Env{status: 200, body: body}} ->
        json(conn, body)

      _other ->
        conn
        |> put_status(500)
        |> render("error.json", message: "Internal Server Error")
    end
  end

  def search(conn, %{"pattern" => pattern}) do
    stops = Ztm.get_all_by_pattern(pattern)

    conn |> render("stops.json", stops: stops)
  end
end
