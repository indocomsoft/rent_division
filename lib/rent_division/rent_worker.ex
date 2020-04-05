defmodule RentDivision.RentWorker do
  @behaviour Honeydew.Worker

  alias RentDivision.Data
  alias RentDivision.Data.Apartment
  alias RentDivision.Data.Valuation

  def run(apartment_id) do
    case Data.metadata_for_worker(apartment_id) do
      nil ->
        nil

      {%Apartment{rent: rent, valuations: valuations}, num_renters} ->
        preamble = [num_renters, rent]

        formatted_valuations =
          Enum.map(
            valuations,
            fn %Valuation{renter_id: renter_id, room_id: room_id, value: value} ->
              Enum.join([renter_id, room_id, value], " ")
            end
          )

        input = Enum.join(preamble ++ formatted_valuations, "\n")
        IO.puts(input)
    end
  end
end
