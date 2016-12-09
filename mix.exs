defmodule Watch.Mixfile do
  use Mix.Project

  def project do
    [app: :watch_probe,
     version: "0.1.0",
     elixir: "~> 1.3",
     description: "Scans a local network for mac address and reports to mothership",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     package: package]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:distillery, :logger, :httpoison, :poison, :exrm_deb], mod: {DevicePresenceProbe, []}]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:httpoison, "~> 0.9.0"},
    {:distillery, "~> 0.10"},
    {:poison, "~> 3.0"},
    {:exrm_deb, "~> 0.0.1"}]
  end

  def package do
   [
      external_dependencies: ['arp-scan'],
      license_file: "LICENSE",
      files: [ "lib", "mix.exs", "README*", "LICENSE"],
      maintainers: ["Russell Osborne <russell@theironyard.com>"],
      licenses: ["MIT"],
      vendor: "Russell Osborne",
      links:  %{
        "GitHub" => "https://github.com/rposborne/device_presence_probe",
      }
   ]
end
end
