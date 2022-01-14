defmodule Ztm.Tasks.DownloadStops do
  require Logger

  @spec call() :: {:ok, nonempty_binary()} | {:error, :unssucessful_download | :unknown}
  def call do
    case Ztm.Api.FetchStopsFile.call() do
      {:ok, %Tesla.Env{status: 200, body: body, headers: headers}} ->
        save_file(body, Enum.into(headers, %{}))

      {:ok, %Tesla.Env{status: status, body: body}} ->
        Logger.error("Unsuccessful download, status: #{status}, body: #{inspect(body)}")

        {:error, :unssucessful_download}

      {:error, reason} ->
        Logger.error("Unknown error on download stops, reason: #{inspect(reason)}")

        {:error, :unknown}
    end
  end

  defp save_file(body, headers) do
    "attachment; filename=" <> filename = Map.get(headers, "content-disposition")
    filename = String.replace(filename, "\"", "")
    path = "/tmp/#{filename}"

    case File.exists?(path) do
      true -> {:ok, path}
      false -> write_to_file(path, body)
    end
  end

  defp write_to_file(path, body) do
    with {:ok, file} <- File.open(path, [:write]),
         :ok <- IO.binwrite(file, body) do
      :ok = File.close(file)

      {:ok, path}
    else
      {:error, reason} ->
        Logger.error(reason)

        {:error, reason}
    end

    {:ok, path}
  end
end
