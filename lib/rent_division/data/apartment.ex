defmodule RentDivision.Data.Apartment do
  use Ecto.Schema

  import Ecto.Changeset

  alias RentDivision.Data.JobStatus
  alias RentDivision.Data.Renter
  alias RentDivision.Data.Room
  alias RentDivision.Data.Valuation
  alias RentDivision.Data.Result

  schema "apartments" do
    field :name, :string
    field :rent, :integer
    field :attempts, :integer, default: 0
    field :status, JobStatus, default: :insufficient_data

    has_many :rooms, Room
    has_many :renters, Renter
    has_many :valuations, Valuation
    has_many :results, Result

    timestamps()
  end

  @required_fields [:name, :rent]

  def changeset(%__MODULE__{} = apartment, params \\ %{}) do
    apartment
    |> cast(params, @required_fields)
    |> validate()
  end

  def update_changeset(%__MODULE__{} = apartment, params \\ %{}) do
    apartment
    |> cast(params, @required_fields ++ [:attempts, :status])
    |> validate()
  end

  def validate(changeset) do
    changeset
    |> validate_required(@required_fields)
    |> validate_number(:rent, greater_than: 0)
    |> validate_number(:attempts, greater_than: 0)
  end
end
