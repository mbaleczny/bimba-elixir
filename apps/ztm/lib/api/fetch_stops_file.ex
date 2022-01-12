defmodule Ztm.Api.FetchStopsFile do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://www.ztm.poznan.pl/pl/dla-deweloperow")
  plug(Tesla.Middleware.Logger)

  def call do
    token = Application.get_env(:ztm, :api_token)

    get("/getGTFSFile", query: [token: token])
  end
end
