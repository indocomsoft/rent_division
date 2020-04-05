defmodule RentDivision.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias RentDivision.RentWorker

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      RentDivision.Repo,
      # Start the endpoint when the application starts
      RentDivisionWeb.Endpoint
      # Starts a worker by calling: RentDivision.Worker.start_link(arg)
      # {RentDivision.Worker, arg},
    ]

    :ok = Honeydew.start_queue(:rent_queue, success_mode: {Honeydew.SuccessMode.Log, []})
    :ok = Honeydew.start_workers(:rent_queue, RentWorker, num: 1)

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RentDivision.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    RentDivisionWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
