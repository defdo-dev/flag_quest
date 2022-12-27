defmodule FlagQuest.Repo.Migrations.CreateDefdoFlags do
  @moduledoc false
  use Ecto.Migration

  def change do
    create table(:defdo_flags) do
      add :name, :string, comment: "The name of the country flag"
      add :image, :string, comment: "The country flag image url"

      timestamps()
    end
  end
end
