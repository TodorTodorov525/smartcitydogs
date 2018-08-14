defmodule Smartcitydogs.Mixfile do
  use Mix.Project

  def project do
    [
      app: :smartcitydogs,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Smartcitydogs.Application, []},
      extra_applications: [
        :logger,
        :runtime_tools,
        :bamboo,
        :timex,
        :bamboo_smtp,
        :ueberauth_facebook,
        :ueberauth_twitter,
        :scrivener_ecto,
        :httpoison,
        :recaptcha
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.3.2"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.2"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:bcrypt_elixir, "~> 1.0"},
      {:cowboy, "~> 1.0"},
      {:calendar, "~> 0.17.2"},
      {:comeonin, "~> 2.5"},
      {:guardian, "~> 0.12.0"},
      {:ueberauth_facebook, "~> 0.3"},
      {:ueberauth_twitter, "~> 0.2"},
      {:oauth, github: "tim/erlang-oauth"},
      {:bamboo, "~> 0.7"},
      {:bamboo_smtp, "~> 1.4.0"},
      {:mock, "~> 0.2.0", only: :test},
      {:timex, "~> 3.1"},
      {:scrivener_ecto, "~> 1.0"},
      {:scrivener_list, "~> 1.0"},
      {:httpoison, "~> 1.0", override: true},
      {:html_entities, "~> 0.4"},
      {:cmark, "~> 0.7"},
      {:recaptcha, "~> 2.3"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
