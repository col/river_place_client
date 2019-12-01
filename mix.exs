defmodule RiverPlaceClient.Mixfile do
  use Mix.Project

  def project do
    [
      app: :river_place_client,
      version: "0.1.0",
      elixir: "~> 1.9",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: "Library for booking tennis courts on riverplace.sg",
      package: package(),
      deps: deps()
    ]
  end

  def package do
    [
      maintainers: ["Colin Harris"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/col/river_place_client"}
    ]
  end

  def application do
    [
      applications: [:logger, :httpoison]
    ]
  end

  defp deps do
    [
      {:httpoison, ">= 1.6.2"},
      {:poison, ">= 2.2.0"},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end
end
