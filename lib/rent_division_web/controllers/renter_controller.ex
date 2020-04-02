defmodule RentDivisionWeb.RenterController do
  use RentDivisionWeb, :controller

  alias RentDivision.Data

  def show(conn, %{"renter_id" => renter_id}) do
    renter = Data.get_renter!(renter_id)
    render(conn, "index.json", renter: renter)
  end

  def create(conn, %{"apartment_id" => apartment_id, "names" => names}) do
    apartment = Data.get_apartment_without_preload!(apartment_id)

    case Data.create_renters(apartment, names) do
      {:ok, renters} ->
        render(conn, "many.json", renters: renters)

      {:error, :already_done} ->
        conn
        |> put_status(:conflict)
        |> put_view(RentDivisionWeb.ErrorView)
        |> render("already_done.json", [])

      {:error, changeset} ->
        render_error_changeset(conn, changeset)
    end
  end
end
