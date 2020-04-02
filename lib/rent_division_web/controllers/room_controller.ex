defmodule RentDivisionWeb.RoomController do
  use RentDivisionWeb, :controller

  alias RentDivision.Data

  def create(conn, %{"apartment_id" => apartment_id, "names" => names}) do
    apartment = Data.get_apartment_without_preload!(apartment_id)

    case Data.create_rooms(apartment, names) do
      {:ok, rooms} ->
        render(conn, "many.json", rooms: rooms)

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
