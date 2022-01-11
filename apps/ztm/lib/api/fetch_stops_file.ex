defmodule Ztm.Api.FetchStopsFile do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://www.ztm.poznan.pl/pl/dla-deweloperow")
  plug(Tesla.Middleware.Logger)

  @token "your-token"

  def call, do: get("/getGTFSFile", query: [token: @token])
end
