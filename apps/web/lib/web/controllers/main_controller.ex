defmodule Web.V1.MainController do
  use Web, :controller

  def request(conn, params) do
    case Ztm.Api.PekaRequest.call(params) do
      {:ok, %Tesla.Env{status: 200, body: body}} ->
        json(conn, body)

      _other ->
        conn
        |> put_status(500)
        |> render("error.json", message: "Internal Server Error")
    end
  end

  def search(conn, %{"pattern" => query}) do
    stops = Ztm.ListStopPointsByName.call(query)

    conn |> render("stops.json", stops: stops)
  end
end
