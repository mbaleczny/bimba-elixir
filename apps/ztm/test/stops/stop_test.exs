defmodule Ztm.Stops.StopTest do
  use Postgres.DataCase, async: true
  alias Ztm.Stops.Stop

  describe "get_all_by_name_pattern/1" do
    test "returns records matched by name with accent" do
      {:ok, stop_1} = create_stop(1, "Półwiejska 1", "POLW41")
      {:ok, _stop_2} = create_stop(3, "Polanka", "POKA41")

      [result] = Stop.get_all_by_name_pattern("polw")

      assert result.stop_name == stop_1.stop_name
    end
  end

  defp create_stop(id, name, code) do
    %{
      stop_id: id,
      stop_name: name,
      stop_code: code,
      stop_lat: Decimal.new(0),
      stop_lon: Decimal.new(0),
      zone_id: "A"
    }
    |> Stop.create()
  end
end
