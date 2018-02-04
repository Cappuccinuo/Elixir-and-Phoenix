defmodule Calc.MixProject do
  use Mix.Project
  def version(), do: "1.0.0"

  def project do
    [
      app: :calc,
      version: version(),
      elixir: "~> 1.6",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: "Calculator",
      package: package(),
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp aliases do
    [
      build: [ &build_releases/1],
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.12"},
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
    ]
  end

  defp package do
    [
      maintainers: [" Yuan "],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/Cappuccinuo/Elixir-and-Phoenix/tree/master/calc"}
    ]
  end

  defp build_releases(_) do
    Mix.Tasks.Compile.run([])
    Mix.Tasks.Archive.Build.run([])
    Mix.Tasks.Archive.Build.run(["--output=calc.ez"])
    File.rename("calc.ez", "./calc_archives/calc.ez")
    File.rename("calc-#{version()}.ez", "./calc_archives/calc-#{version()}.ez")
  end
end
