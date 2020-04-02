defmodule RentDivisionWeb.ApartmentView do
  use RentDivisionWeb, :view

  alias RentDivision.Data.Apartment
  alias RentDivision.Data.Result

  def render("single.json", %{
        apartment: %Apartment{
          id: id,
          name: name,
          rent: rent,
          status: status,
          attempts: attempts,
          rooms: rooms,
          renters: renters,
          results: results
        }
      }) do
    results =
      Enum.map(results, fn %Result{
                             rent: rent,
                             apartment_id: apartment_id,
                             renter_id: renter_id,
                             room_id: room_id
                           } ->
        %{rent: rent, apartment_id: apartment_id, renter_id: renter_id, room_id: room_id}
      end)

    %{
      id: id,
      name: name,
      rent: rent,
      status: status,
      attempts: attempts,
      rooms: render_many(rooms, RentDivisionWeb.RoomView, "single.json"),
      renters: render_many(renters, RentDivisionWeb.RenterView, "single.json"),
      results: results
    }
  end
end
