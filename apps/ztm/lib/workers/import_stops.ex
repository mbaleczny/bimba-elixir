defmodule Ztm.Workers.ImportStops do
  require Logger

  @stops_file "stops.txt"

  def call do
    with {:download_stops, {:ok, zip_file_path}} <-
           {:download_stops, Ztm.Tasks.DownloadStops.call()},
         {:extract_contents, {:ok, contents}} <-
           {:extract_contents, extract_contents(zip_file_path)},
         {:extract_stops_file, {:ok, stops_file_path}} <-
           {:extract_stops_file, extract_stops_file(contents)},
         {:parse_stops, {:ok, rows}} <- {:parse_stops, parse_stops(stops_file_path)},
         {:replace_stops, {:ok, :success}} <-
           {:replace_stops, Ztm.Stops.Stop.replace_all_with(rows)},
         {:clean_up, :ok} <- {:clean_up, remove_zip_file_and_extracted_folder(zip_file_path)} do
      _ = Logger.debug("Removed temporary files")

      :ok
    else
      {:download_stops, reason} ->
        _ = Logger.error("Error while downloading stops, reason: #{inspect(reason)}")

        :error

      {:extract_contents, reason} ->
        _ = Logger.error("Error while extracting zip file, reason: #{inspect(reason)}")

        :error

      {:extract_stops_file, reason} ->
        _ = Logger.error("Error while extracting stops file, reason: #{inspect(reason)}")

        :error

      {:parse_stops, reason} ->
        _ = Logger.error("Error while parsing stops records, reason: #{inspect(reason)}")

        :error

      {:replace_stops, reason} ->
        _ =
          Logger.error("Error while replacing stops database records, reason: #{inspect(reason)}")

        :error

      {:clean_up, reason} ->
        _ = Logger.error("Error while clean up, reason: #{inspect(reason)}")

        :error

      {:error, reason} ->
        _ = Logger.error("Unknown error while importing stops, reason: #{inspect(reason)}")

        :error
    end
  end

  defp remove_zip_file_and_extracted_folder(file) do
    folder = get_extract_folder(file)

    if String.match?(folder, ~r/\/tmp\/\w+/) do
      File.rm_rf(folder)
    end

    File.rm(file)
  end

  defp extract_stops_file(contents) when is_list(contents) do
    contents
    |> Enum.map(&to_string/1)
    |> Enum.find(nil, &String.ends_with?(&1, @stops_file))
    |> case do
      nil -> {:error, "Missing stops.txt file"}
      file_path -> {:ok, file_path}
    end
  end

  defp extract_contents(file_path) when is_binary(file_path) do
    folder = get_extract_folder(file_path)
    _ = File.mkdir(folder)

    :zip.unzip(~c'#{file_path}', [{:cwd, ~c'/tmp'}])
  end

  defp get_extract_folder(filename) when is_binary(filename) do
    String.replace(filename, ".zip", "/")
  end

  defp parse_stops(file_path) do
    file_path
    |> File.stream!()
    |> CSV.decode!(headers: true, separator: ?,)
    |> Enum.to_list()
    |> then(&{:ok, &1})
  catch
    reason -> {:error, reason}
  end
end
