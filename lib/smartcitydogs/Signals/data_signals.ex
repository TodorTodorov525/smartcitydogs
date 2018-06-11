defmodule Smartcitydogs.DataSignals do
  import Ecto.Query, warn: false
  alias Smartcitydogs.Repo

  alias Smartcitydogs.Signals
  alias Smartcitydogs.SignalsTypes
  alias Smartcitydogs.SignalsComments
  alias Smartcitydogs.SignalsCategories
  alias Smartcitydogs.User
  alias Smartcitydogs.SignalImages

  import Plug.Conn

  # Signals

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

    ### takes the support_count
  def get_signal_support_count(signal_id) do
    query = Ecto.Query.from(c in Signals, where: c.id == ^signal_id) #select: %{ count: c.support_count },
    Repo.all(query)
  end

  def list_signals() do
    Repo.all(Signals)
  end

  def change_signal(%Signals{} = signal) do
    Signals.changeset(signal, %{})
  end

  def get_signal(id) do
    Repo.get!(Signals, id)
  end

  def delete_signal(id) do
    get_signal(id)
    |> Repo.delete()
  end

  # Signal iamges

  def get_signal_image_id(signals_id) do
    query = Ecto.Query.from(c in SignalImages, where: c.signals_id == ^signals_id)
    Repo.all(query)
  end

  def get_signal_images(id) do
    Repo.get!(SignalImages, id)
  end

  def list_signal_images() do
    Repo.all(SignalImages)
  end

  def create_signal_images(args \\ %{}) do
    %SignalImages{}
    |> SignalImages.changeset(args)
    |> Repo.insert()
  end

  def update_signal_images(%SignalImages{} = images, args) do
    images
    |> SignalImages.changeset(args)
    |> Repo.update()
  end

  def delete_signal_images(id) do
    get_signal_images(id)
    |> Repo.delete()
  end

  # Signals types

  def get_signal_type(id) do
    Repo.get!(SignalsTypes, id)
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

  def delete_signal_type(id) do
    get_signal_type(id)
    |> Repo.delete()
  end

  # Signal comments

  def get_signal_comment(id) do
    Repo.get!(SignalsComments, id)
  end

  def list_signal_comment() do
    Repo.all(SignalsComments)
  end

  def get_comment_signal_id(signals_id) do
    query = Ecto.Query.from(c in SignalsComments, where: c.signals_id == ^signals_id)
    Repo.all(query)
  end

  def create_signal_comment(args \\ %{}) do
    IO.inspect(args)
    IO.puts "_________________________________________________"
    %SignalsComments{}
    |> SignalsComments.changeset(args)
    |> Repo.insert()
  end

  def update_signal_comment(%SignalsComments{} = comments, args) do
    comments
    |> SignalsComments.changeset(args)
    |> Repo.update()
  end

  def delete_signal_comment(id) do
    get_signal_comment(id)
    |> Repo.delete()
  end

  # Signals category

  def get_signal_category(id) do
    Repo.get!(SignalsCategories, id)
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

  def delete_signal_category(id) do
    get_signal_category(id)
    |> Repo.delete()
  end
end