defmodule RentDivisionWeb.RoomView do
  use RentDivisionWeb, :view

  alias RentDivision.Data.Room

  def render("many.json", %{rooms: rooms}) do
    render_many(rooms, __MODULE__, "single.json")
  end

  def render("single.json", %{room: %Room{id: id, name: name}}) do
    %{id: id, name: name}
  end
end
