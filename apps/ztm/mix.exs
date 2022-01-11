defmodule Ztm.MixProject do
  use Mix.Project

  def project do
    [
      aliases: aliases(),
      app: :ztm,
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps: deps(),
      deps_path: "../../deps",
      elixir: "~> 1.13",
      lockfile: "../../mix.lock",
      start_permanent: Mix.env() == :prod,
      version: "0.1.0"
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Ztm.Application, []}
    ]
  end

  defp deps do
    [
      {:csv, "~> 2.3"},
      {:httpoison, "~> 1.5"},
      {:jason, "~> 1.1"},
      {:quantum, "~> 2.3"},
      {:tesla, "~> 1.4"},
      # umbrella
      {:postgres, in_umbrella: true}
    ]
  end

  defp aliases do
    [setup: []]
  end
end
