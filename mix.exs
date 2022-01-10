defmodule Postgres.Umbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      aliases: aliases(),
      deps: deps(),
      start_permanent: Mix.env() == :prod,
      version: "0.1.0"
    ]
  end

  defp deps do
    []
  end

  defp aliases do
    [
      # run `mix setup` in all child apps
      setup: ["cmd mix setup"],
      test: ["cmd mix test"]
    ]
  end
end
