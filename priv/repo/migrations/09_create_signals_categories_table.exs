defmodule Smartcitydogs.Repo.Migrations.SignalCategory do
  use Ecto.Migration

  def change do
    create table("signal_category") do
      add(:name, :text)
      add(:deleted_at, :naive_datetime)
      timestamps()
    end
  end
end
