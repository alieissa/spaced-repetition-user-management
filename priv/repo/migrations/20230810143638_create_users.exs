defmodule Users.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :password, :string, null: false
      add :email, :string, null: false
      add :first_name, :string, null: true
      add :last_name, :string, null: true

      timestamps()
    end

    create unique_index(:users, [:email])
  end
end
