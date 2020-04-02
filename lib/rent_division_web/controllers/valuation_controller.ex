defmodule RentDivisionWeb.ValuationController do
  use RentDivisionWeb, :controller

  alias RentDivision.Data

  def create(conn, %{"renter_id" => renter_id, "valuations" => valuations}) do
    renter = Data.get_renter_without_preload!(!renter_id)

    case Data.create_valuations(renter, valuations) do
      {:ok, valuations} ->
        render(conn, "many.json", valuations: valuations)

      {:error, :already_done} ->
        conn
        |> put_status(:conflict)
        |> put_view(RentDivisionWeb.ErrorView)
        |> render("already_done.json", [])

      {:error, :wrong_sum} ->
        conn
        |> put_status(:bad_request)
        |> put_view(RentDivisionWeb.ErrorView)
        |> render("bad_sum.json", [])

      {:error, changeset} ->
        render_error_changeset(conn, changeset)
    end
  end
end
