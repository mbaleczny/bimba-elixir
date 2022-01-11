defmodule Web.V1.MainView do
  use Web, :view

  def render("stops.json", %{stops: stops}) do
    %{
      success: Enum.map(stops, &%{name: &1.stop_name, symbol: &1.stop_code})
    }
  end
end
