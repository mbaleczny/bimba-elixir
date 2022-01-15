defmodule Ztm do
  defdelegate get_stops_by_name_pattern(pattern),
    to: Ztm.Stops.Stop,
    as: :get_all_by_name_pattern

  defdelegate peka_api_request(body),
    to: Ztm.Api.PekaRequest,
    as: :call
end
