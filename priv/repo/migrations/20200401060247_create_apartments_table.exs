defmodule RentDivision.Repo.Migrations.CreateApartmentsTable do
  use Ecto.Migration

  alias RentDivision.Data.JobStatus

  def change do
    JobStatus.create_type()

    create table("apartments") do
      add :name, :string, null: false
      add :rent, :integer, null: false
      add :attempts, :integer, null: false
      add :status, JobStatus.type(), null: false

      timestamps()
    end
  end
end
