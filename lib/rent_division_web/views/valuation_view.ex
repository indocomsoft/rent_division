defmodule RentDivisionWeb.ValuationView do
  use RentDivisionWeb, :view

  alias RentDivision.Data.Valuation

  def render("many.json", %{valuations: valuations}) do
    render_many(valuations, __MODULE__, "single.json")
  end

  def render("single.json", %{valuation: %Valuation{room_id: room_id, value: value}}) do
    %{room_id: room_id, value: value}
  end
end
