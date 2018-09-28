defmodule Smartcitydogs.Repo.Migrations.UsersTypes do
  use Ecto.Migration

  def up do
    create table("users_types") do
      add(:name, :text)
      add(:deleted_at, :naive_datetime)
      timestamps()
    end
  end
end