defmodule CovidPager.MixProject do
  use Mix.Project

  def project do
    [
      app: :covid_pager,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: [],
      extra_applications: [:logger, :inets, :ssl]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:aws_lambda_elixir_runtime, "~> 0.1.0"},
      {:distillery, "~> 2.0"},
      {:jason, "~> 1.3"}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
