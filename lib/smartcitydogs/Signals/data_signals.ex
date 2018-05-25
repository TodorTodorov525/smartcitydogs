defmodule Smartcitydogs.DataSignals do

  import Ecto.Query, warn: false
  alias Smartcitydogs.Repo

  alias Smartcitydogs.Signals
  alias Smartcitydogs.SignalsTypes
  alias Smartcitydogs.SignalsComments
  alias Smartcitydogs.SignalsCategories
  alias Smartcitydogs.User

  import Plug.Conn

  #Signals

  def create_signal(args \\ %{}) do
    %Signals{}
    |> Signals.changeset(args)
    |> Repo.insert()
  end

  def update_signal(%Signals{} = signals, args) do
    signals
    |> Signals.changeset(args)
    |> Repo.update()
  end

  def list_signals() do
    Repo.all(Signals)
  end

  def get_signal(id) do
    Repo.get!(Signals,id)
  end

  #Signals types

  def get_signal_type(id) do
    Repo.get!(SignalsTypes,id)
  end

  def list_signal_types() do
    Repo.all(SignalsTypes)
  end

  def create_signal_type(args \\ %{}) do
    %SignalsTypes{}
    |> SignalsTypes.changeset(args)
    |> Repo.insert()
  end

  def update_signal_type(%SignalsTypes{} = types, args) do
    types
    |> SignalsTypes.changeset(args)
    |> Repo.update()
  end

  #Signal comments

  def get_signal_comment(id) do
    Repo.get!(SignalsComments,id)
  end

  def list_signal_comment() do
    Repo.all(SignalsComments)
  end

  def create_signal_comment(args \\ %{}) do
    %SignalsComments{}
    |> SignalsComments.changeset(args)
    |> Repo.insert()
  end

  def update_signal_comment(%SignalsComments{} = comments, args) do
    comments
    |> SignalsComments.changeset(args)
    |> Repo.update()
  end

  #Signals category

  def get_signal_category(id) do
    Repo.get!(SignalsCategories,id)
  end

  def list_signal_category() do
    Repo.all(SignalsCategories)
  end

  def create_signal_category(args \\ %{}) do
    %SignalsCategories{}
    |> SignalsCategories.changeset(args)
    |> Repo.insert()
  end

  def update_signal_category(%SignalsCategories{} = category, args) do
    category
    |> SignalsCategories.changeset(args)
    |> Repo.update()
  end


end
