defmodule RentDivision.Repo.Migrations.CreateRentersTable do
  use Ecto.Migration

  def change do
    create table("renters") do
      add :name, :string, null: false
      add :apartment_id, references("apartments", on_delete: :delete_all), null: false

      timestamps()
    end

    create index("renters", [:apartment_id])
    create unique_index("renters", [:name, :apartment_id])
  end
end
