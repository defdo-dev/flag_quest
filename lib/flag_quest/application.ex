defmodule FlagQuest.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      FlagQuestWeb.Telemetry,
      # Start the Ecto repository
      FlagQuest.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: FlagQuest.PubSub},
      # Start Finch
      {Finch, name: FlagQuest.Finch},
      # Start the Endpoint (http/https)
      FlagQuestWeb.Endpoint
      # Start a worker by calling: FlagQuest.Worker.start_link(arg)
      # {FlagQuest.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FlagQuest.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FlagQuestWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
