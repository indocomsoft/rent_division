defmodule RentDivision.Data.Renter do
  @moduledoc """
  Represents a renter in an apartment
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias RentDivision.Data.Apartment
  alias RentDivision.Data.Valuation

  schema "renters" do
    field :name, :string
    belongs_to :apartment, Apartment

    has_many :valuations, Valuation

    timestamps()
  end

  @required_fields [:name, :apartment_id]

  def changeset(%__MODULE__{} = renter, params \\ %{}) do
    renter
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> foreign_key_constraint(:apartment_id)
    |> unique_constraint(:name,
      name: :renters_name_apartment_id_index,
      message: "must be unique in the same apartment"
    )
  end
end
