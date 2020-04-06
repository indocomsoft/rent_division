defmodule RentDivision.Data.Valuation do
  @moduledoc """
  Represents a valuation given by a renter to a room in an apartment.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias RentDivision.Data.Apartment
  alias RentDivision.Data.Renter
  alias RentDivision.Data.Room

  schema "valuations" do
    field :value, :integer

    belongs_to :apartment, Apartment
    belongs_to :renter, Renter
    belongs_to :room, Room

    timestamps()
  end

  @required_fields [:value, :apartment_id, :renter_id, :room_id]

  def changeset(%__MODULE__{} = valuation, params \\ %{}) do
    valuation
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> validate_number(:value, greater_than: 0)
    |> foreign_key_constraint(:apartment_id)
    |> foreign_key_constraint(:room_id)
    |> foreign_key_constraint(:renter_id)
    |> unique_constraint(:apartment_id, name: :valuations_apartment_id_renter_id_room_id_index)
  end
end
