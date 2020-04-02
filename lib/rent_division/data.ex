defmodule RentDivision.Data do
  import Ecto.Query, warn: false

  alias RentDivision.Repo
  alias RentDivision.Data.Apartment
  alias RentDivision.Data.Renter
  alias RentDivision.Data.Room
  alias RentDivision.Data.Valuation

  @doc """
  Also preloads rooms and renters
  """
  def get_apartment!(id) do
    Apartment
    |> preload([:rooms, :renters, :results])
    |> Repo.get!(id)
  end

  def get_apartment_without_preload!(id), do: Repo.get!(Apartment, id)

  def create_apartment(attrs \\ %{}) do
    %Apartment{}
    |> Apartment.changeset(attrs)
    |> Repo.insert()
    |> case do
      {:ok, apartment} -> {:ok, Repo.preload(apartment, [:rooms, :renters, :results])}
      {:error, changeset} -> {:error, changeset}
    end
  end

  defp update_apartment(%Apartment{} = apartment, attrs) do
    apartment
    |> Apartment.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_apartment(%Apartment{} = apartment) do
    Repo.delete(apartment)
  end

  def get_room!(id), do: Repo.get!(Room, id)

  defp create_room(attrs \\ %{}) do
    %Room{}
    |> Room.changeset(attrs)
    |> Repo.insert()
  end

  def delete_room(%Room{} = room) do
    Repo.delete(room)
  end

  @doc """
  Also preloads apartment
  """
  def get_renter!(id) do
    Renter
    |> preload([:valuations, apartment: :rooms])
    |> Repo.get!(id)
  end

  def get_renter_without_preload!(id), do: Repo.get!(Renter, id)

  defp create_renter(attrs \\ %{}) do
    %Renter{}
    |> Renter.changeset(attrs)
    |> Repo.insert()
  end

  def delete_renter(%Renter{} = renter) do
    Repo.delete(renter)
  end

  def get_valuation!(id), do: Repo.get!(Valuation, id)

  defp create_valuation(attrs \\ %{}) do
    %Valuation{}
    |> Valuation.changeset(attrs)
    |> Repo.insert()
  end

  def delete_valuation(%Valuation{} = valuation) do
    Repo.delete(valuation)
  end

  def create_rooms(%Apartment{id: apartment_id}, room_names) when is_list(room_names) do
    Room
    |> where(apartment_id: ^apartment_id)
    |> Repo.exists?()
    |> case do
      false ->
        Repo.transaction(fn ->
          Enum.map(room_names, fn room_name ->
            case create_room(%{"apartment_id" => apartment_id, "name" => room_name}) do
              {:ok, room} -> room
              {:error, changeset} -> Repo.rollback(changeset)
            end
          end)
        end)

      true ->
        {:error, :already_done}
    end
  end

  def create_renters(%Apartment{id: apartment_id}, names) when is_list(names) do
    Renter
    |> where(apartment_id: ^apartment_id)
    |> Repo.exists?()
    |> case do
      false ->
        Repo.transaction(fn ->
          Enum.map(names, fn name ->
            case create_renter(%{"apartment_id" => apartment_id, "name" => name}) do
              {:ok, renter} -> renter
              {:error, changeset} -> Repo.rollback(changeset)
            end
          end)
        end)

      true ->
        {:error, :already_done}
    end
  end

  def update_apartment_status(apartment = %Apartment{id: id}) do
    apartment_query = Apartment |> where(id: ^id)

    num_valuations =
      apartment_query
      |> join(:inner, [a], v in assoc(a, :valuations))
      |> Repo.aggregate(:count)

    num_renters =
      apartment_query
      |> join(:inner, [a], r in assoc(a, :renters))
      |> Repo.aggregate(:count)

    num_rooms =
      apartment_query
      |> join(:inner, [a], r in assoc(a, :rooms))
      |> Repo.aggregate(:count)

    if num_valuations == num_renters * num_rooms do
      update_apartment(apartment, %{status: :ready})
      # TODO async invoke job
    end
  end

  def create_valuations(%Renter{id: renter_id, apartment_id: apartment_id}, valuations)
      when is_map(valuations) do
    apartment = get_apartment_without_preload!(apartment_id)

    sum = valuations |> Map.values() |> Enum.sum()

    if sum == apartment.rent do
      Valuation
      |> where(renter_id: ^renter_id, apartment_id: ^apartment_id)
      |> Repo.exists?()
      |> case do
        false ->
          Repo.transaction(fn ->
            result =
              Enum.map(valuations, fn {room_id, value} ->
                case create_valuation(%{
                       "apartment_id" => apartment_id,
                       "renter_id" => renter_id,
                       "room_id" => room_id,
                       "value" => value
                     }) do
                  {:ok, valuation} -> valuation
                  {:error, changeset} -> Repo.rollback(changeset)
                end
              end)

            update_apartment_status(apartment)

            result
          end)

        true ->
          {:error, :already_done}
      end
    else
      {:error, :wrong_sum}
    end
  end
end
