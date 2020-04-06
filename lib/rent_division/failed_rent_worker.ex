defmodule RentDivision.FailedRentWorker do
  @moduledoc """
  Failed rent division jobs are eventually moved to the queue of this worker which simply marks the
  apartment as failed.
  """

  @behaviour Honeydew.Worker

  alias RentDivision.Data

  def run(apartment_id) do
    apartment = Data.get_apartment_without_preload!(apartment_id)
    {:ok, _} = Data.update_apartment(apartment, %{status: :failed})
  end
end
