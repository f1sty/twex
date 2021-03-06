defmodule Twex.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :twex,
      version: @version,
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.6.2"},
      {:jason, "~> 1.1.2"},
      {:oauth2, "~> 2.0.0"},
      {:ex_doc, "~> 0.21.2"},
      {:dialyxir, "~>0.5.1", only: :dev},
      {:credo, "~> 1.1.5", only: [:dev, :test]}
    ]
  end
end
