defmodule Ztm.Workers.ImportStops do
  require Logger

  alias Ztm.Stop

  @stops_file "stops.txt"

  def call do
    case Ztm.DownloadStops.call() do
      {:ok, file} ->
        extract_contents(file)
        |> get_stops_file()
        |> parse_stops()
        |> update_stops()

        case remove_zip_file_and_extracted_folder(file) do
          :ok ->
            Logger.info("Removed temporary files")

            :ok

          error ->
            error
        end

      {:error, reason} ->
        Logger.info(reason)

        {:error, reason}
    end
  end

  defp update_stops(%{results: results, errors: errors}) do
    case results do
      [] ->
        Logger.info("Empty results array.")

      _ ->
        Stop.update_stops(results)
    end

    Logger.info("Imported stops errors: #{errors}")
  end

  defp remove_zip_file_and_extracted_folder(file) do
    folder = get_extract_folder(file)

    if String.match?(folder, ~r/\/tmp\/\w+/) do
      File.rm_rf(folder)
    end

    File.rm(file)
  end

  defp get_stops_file({:ok, contents}) do
    file =
      contents
      |> Enum.map(&to_string/1)
      |> Enum.find(nil, &String.ends_with?(&1, @stops_file))

    if file != nil do
      {:ok, file}
    else
      {:error, "Missing stops.txt file"}
    end
  end

  defp get_stops_file({:error, _} = result), do: result

  defp extract_contents(file_path) when file_path != nil and is_binary(file_path) do
    folder = get_extract_folder(file_path)
    _ = File.mkdir(folder)

    :zip.unzip(~c'#{file_path}', [{:cwd, ~c'#{folder}'}])
  end

  defp extract_contents(_) do
    {:error, "Missing zip file"}
  end

  def get_extract_folder(zip_file) do
    String.replace(zip_file, ".zip", "/")
  end

  defp parse_stops({:ok, path}) do
    File.stream!(path)
    |> CSV.decode(headers: true, separator: ?,)
    |> Enum.map(fn
      {:ok, x} -> {:ok, Stop.changeset(%Stop{}, x)}
      err -> err
    end)
    |> Enum.reduce(
      %{results: [], errors: []},
      fn el, %{results: results, errors: errors} = acc ->
        case el do
          {:ok, ch} -> %{acc | results: results ++ [ch]}
          {:error, err} -> %{acc | errors: errors ++ [err]}
        end
      end
    )
  end

  defp parse_stops({:error, error}), do: %{results: nil, errors: [error]}
end
