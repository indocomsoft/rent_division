defmodule RentDivision.RentWorker do
  @behaviour Honeydew.Worker

  alias RentDivision.Data
  alias RentDivision.Data.Apartment
  alias RentDivision.Data.Valuation

  def run(apartment_id) do
    case Data.metadata_for_worker(apartment_id) do
      nil ->
        nil

      {%Apartment{rent: rent, valuations: valuations} = apartment, num_renters} ->
        preamble = [num_renters, rent]

        formatted_valuations =
          Enum.map(
            valuations,
            fn %Valuation{renter_id: renter_id, room_id: room_id, value: value} ->
              Enum.join([renter_id, room_id, value], " ")
            end
          )

        input = Enum.join(preamble ++ formatted_valuations, "\n")

        path = Briefly.create!()
        File.write!(path, input)

        dir = get_dir!()

        {output, 0} =
          System.cmd("java", [
            "-Djava.library.path=#{Path.join(dir, "lib")}",
            "-cp",
            "#{Path.join(dir, "bin")}:#{Path.join(dir, "cplex.jar")}",
            "Main",
            path
          ])

        {:ok, _} =
          output
          |> String.split("\n", trim: true)
          |> Enum.map(fn line ->
            [renter_id, room_id, value] = String.split(line, " ")
            {parsed_value, ""} = Float.parse(value)
            %{renter_id: renter_id, room_id: room_id, rent: round(parsed_value)}
          end)
          |> Data.create_results(apartment)
    end
  end

  def get_dir!() do
    config =
      Application.get_env(:rent_division, RentDivision.RentWorker) ||
        raise "RentDivision.RentWorker config not set"

    Keyword.get(config, :dir) || raise "RentDivision>RentWorker config does not have :dir key set"
  end
end
