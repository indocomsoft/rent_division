defmodule RentDivisionWeb.RenterView do
  use RentDivisionWeb, :view

  alias RentDivision.Data.Apartment
  alias RentDivision.Data.Renter

  def render("index.json", %{
        renter: %Renter{
          name: name,
          apartment: %Apartment{name: apartment_name, rent: rent, status: status, rooms: rooms},
          valuations: valuations
        }
      }) do
    base_result = %{
      name: name,
      apartment: %{name: apartment_name, rent: rent},
      rooms: render_many(rooms, RentDivisionWeb.RoomView, "single.json")
    }

    case status do
      :insufficient_data ->
        base_result

      _ ->
        Map.put(
          base_result,
          :valuations,
          render_many(valuations, RentDivisionWeb.ValuationView, "single.json")
        )
    end
  end

  def render("many.json", %{renters: renters}) do
    render_many(renters, __MODULE__, "single.json")
  end

  def render("single.json", %{renter: %Renter{id: id, name: name}}) do
    %{id: id, name: name}
  end
end
