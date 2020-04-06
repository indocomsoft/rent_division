defmodule RentDivision.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias RentDivision.Data
  alias RentDivision.FailedRentWorker
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

    :ok =
      Honeydew.start_queue(:failed_rent_queue,
        failure_mode: {Honeydew.FailureMode.Retry, times: 3}
      )

    :ok =
      Honeydew.start_queue(:rent_queue,
        success_mode: {Honeydew.SuccessMode.Log, []},
        failure_mode:
          {Honeydew.FailureMode.Retry,
           times: 3, finally: {Honeydew.FailureMode.Move, queue: :failed_rent_queue}}
      )

    :ok = Honeydew.start_workers(:failed_rent_queue, FailedRentWorker)
    :ok = Honeydew.start_workers(:rent_queue, RentWorker, num: 1)

    compile_rent()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RentDivision.Supervisor]
    result = Supervisor.start_link(children, opts)

    enqueue_ready_apartments()

    result
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    RentDivisionWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp compile_rent do
    dir = RentWorker.get_dir!()

    bin_path = Path.join(dir, "bin")
    File.mkdir_p!(bin_path)

    java_files = Path.wildcard(Path.join(dir, "src/*.java"))

    {_, 0} =
      System.cmd("javac", ["-d", bin_path, "-cp", Path.join(dir, "cplex.jar")] ++ java_files)
  end

  defp enqueue_ready_apartments do
    Enum.map(Data.find_ready_apartment_ids(), &Honeydew.async({:run, [&1]}, :rent_queue))
  end
end
