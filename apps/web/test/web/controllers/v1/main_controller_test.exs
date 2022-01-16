defmodule Web.V1.MainControllerTest do
  use Web.ConnCase

  describe "POST search/1" do
    test "returns 200 with list of stops matched by pattern query", %{conn: conn} do
      {:ok, stop_1} = create_stop(1, "Półwiejska 1", "POLW41")
      {:ok, _stop_2} = create_stop(3, "Polanka", "POKA41")

      params = %{pattern: "polw"}
      conn = post(conn, Routes.main_path(conn, :search), params)

      [stop_result] = json_response(conn, 200)["success"]

      assert stop_result["name"] == stop_1.stop_name
      assert stop_result["symbol"] == stop_1.stop_code
    end
  end

  def create_stop(id, name, code) do
    %{
      stop_id: id,
      stop_name: name,
      stop_code: code,
      stop_lat: Decimal.new(0),
      stop_lon: Decimal.new(0),
      zone_id: "A"
    }
    |> Ztm.Stops.Stop.create()
  end
end
