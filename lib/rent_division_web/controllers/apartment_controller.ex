defmodule RentDivisionWeb.ApartmentController do
  use RentDivisionWeb, :controller

  alias RentDivision.Data

  def show(conn, %{"id" => id}) do
    apartment = Data.get_apartment!(id)
    render(conn, "single.json", apartment: apartment)
  end

  def create(conn, params) do
    case Data.create_apartment(params) do
      {:ok, apartment} -> render(conn, "single.json", apartment: apartment)
      {:error, changeset} -> render_error_changeset(conn, changeset)
    end
  end
end
