defmodule Ztm do
  defdelegate get_all_by_pattern(pattern),
    to: Ztm.Stops.GetAllByPattern,
    as: :call

  defdelegate peka_api_request(body),
    to: Ztm.Api.PekaRequest,
    as: :call
end
