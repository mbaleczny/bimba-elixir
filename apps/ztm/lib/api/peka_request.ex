defmodule Ztm.Api.PekaRequest do
  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://www.peka.poznan.pl")

  plug(Tesla.Middleware.Headers, [
    {"Accept", "application/json;charset=UTF-8"},
    {"Content-Type", "application/x-www-form-urlencoded;charset=UTF-8"}
  ])

  plug(Tesla.Middleware.FormUrlencoded)
  plug(Tesla.Middleware.JSON)
  plug(Tesla.Middleware.Logger)

  def call(params, ts \\ DateTime.utc_now() |> DateTime.to_unix()) do
    post("/vm/method.vm", params, query: [ts: ts])
  end
end
