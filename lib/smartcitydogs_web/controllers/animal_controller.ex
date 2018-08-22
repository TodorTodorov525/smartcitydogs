defmodule SmartcitydogsWeb.AnimalController do
  use SmartcitydogsWeb, :controller

  
  alias Smartcitydogs.DataAnimals
  alias Smartcitydogs.Animals
  alias Smartcitydogs.Repo
  alias SmartcitydogsWeb.AnimalController
  import Ecto.Query

  ###### Send E-mail ########

  def send_email(conn,data) do
    int = String.to_integer(data["animal_id"])
    Smartcitydogs.Email.send_email(data)
    DataAnimals.insert_adopt(data["user_id"], data["animal_id"])
    redirect conn, to: "/registered/#{int}"
  end

  ############################# Minicipality Home Page Animals ################################

  ##Start-up function of filter page for animals
  def minicipality_registered(conn, params) do
    logged_user_type_id = conn.assigns.current_user.users_types.id
    if logged_user_type_id == 3 do
      render(conn, SmartcitydogsWeb.ErrorView, "401.html")
    else
      data_status = case Map.fetch(params, "page") do
        {:ok, num} -> {params["animal_status"], num}
        _ -> {[], "1"}
      end
      AnimalController.get_ticked_checkboxes(conn, data_status)
    end
  end

  ##Get all of the dogs in the shelter
  def minicipality_shelter(conn, _params) do
    struct = from(p in Animals, where: p.animals_status_id == 3)
    all_adopted = Repo.all(struct) |> Repo.preload(:animals_status)
    page = Smartcitydogs.Repo.paginate(all_adopted, page: 1, page_size: 8)
    render(conn, "minicipality_shelter.html", animals: page.entries, page: page)
  end

  ##Get all of the adopted dogs
  def minicipality_adopted(conn, _params) do
    struct = from(p in Animals, where: p.animals_status_id == 2)
    all_adopted = Repo.all(struct) |> Repo.preload(:animals_status)
    page = Smartcitydogs.Repo.paginate(all_adopted, page: 1, page_size: 8)
    render(conn, "minicipality_adopted.html", animals: page.entries, page: page)
  end

  ##Get all of the ticked checkboxes from the filters, handle redirection to pagination pages.
  def get_ticked_checkboxes(conn, params) do
    {data_status, num} = params
    data_status = 
      case data_status do
        nil -> []
        _ -> data_status
      end
    num = String.to_integer(num)
    cond do
      data_status != []->
        all_query = []
        x =
        Enum.map(data_status, fn x ->
          struct = from(p in Animals, where: p.animals_status_id == ^String.to_integer(x))
          (all_query ++ Repo.all(struct)) |> Repo.preload(:animals_status) |> Repo.preload(:animals_image)
        end)
        x = List.flatten(x)
        list_animals = Smartcitydogs.Repo.paginate(x, page: num, page_size: 8)
        render(conn, "minicipality_registered.html", animals: list_animals.entries, page: list_animals, data: data_status)
      true ->
        x = DataAnimals.list_animals()
        page = Smartcitydogs.Repo.paginate(x, page: num, page_size: 8)
        render(conn, "minicipality_registered.html", animals: page.entries, page: page, data: data_status)
      end
  end

  ##When the search button is clicked, for rendering the first page of the query.
  def filter_registered(conn, params) do
    data_status =  
      for  {k , v}  <- params do
        cond do 
          k |> String.match?( ~r/animal_status./) && v != "false" -> 
            v   
          true ->
            nil
        end
      end
    data_status = Enum.filter(data_status, & !is_nil(&1))
    cond do
      data_status != []->
        all_query = []
        x =
        Enum.map(data_status, fn x ->
          struct = from(p in Animals, where: p.animals_status_id == ^String.to_integer(x))
          (all_query ++ Repo.all(struct)) |> Repo.preload(:animals_status)
        end)
          page = Smartcitydogs.Repo.paginate( List.flatten(x) , page: 1, page_size: 8)
          render(conn, "minicipality_registered.html", animals: page.entries, page: page, data: data_status )
      true -> 
         x = DataAnimals.list_animals()
        page = Smartcitydogs.Repo.paginate(x, page: 1, page_size: 8)
        render(conn, "minicipality_registered.html", animals: page.entries, page: page, data: data_status)
    end
  end


  ############################# /Minicipality Home Page Animals ################################

  ##Render for regular users
  def index(conn, params) do
    sorted_animals = DataAnimals.sort_animals_by_id()

    if conn.assigns.current_user != nil do
      logged_user_type_id = conn.assigns.current_user.users_types.id
      if logged_user_type_id == 3 do
        render(conn, SmartcitydogsWeb.ErrorView, "401.html")
      else
        index_rendering(conn, params, sorted_animals)
      end
    else
      index_rendering(conn, params, sorted_animals)
    end
  end

  ##Handle search by chip number filter.
  defp index_rendering(conn, params, sorted_animals) do
    cond do
      params == %{} || (params["page"] == nil && params["chip_number"] == "") ->
        page = Smartcitydogs.Repo.paginate(sorted_animals, page: 1, page_size: 8)

        list_animals =
          Map.get(page, :entries)
          |> Repo.preload(:animals_status)
          |> Repo.preload(:animals_image)

        render(
          conn,
          "index.html",
          animals: list_animals,
          page: page,
          chip_number: params["chip_number"]
        )

      params != %{} && params["page"] != nil ->
        num = String.to_integer(params["page"])
        animals = DataAnimals.get_animal_by_chip(params["chip_number"])
        page = Smartcitydogs.Repo.paginate(animals, page: num, page_size: 8)

        render(
          conn,
          "index.html",
          animals: page.entries,
          page: page,
          chip_number: params["chip_number"]
        )

      params["chip_number"] != nil ->
        chip = params["chip_number"]
        animals = DataAnimals.get_animal_by_chip(chip) |> Repo.preload(:animals_status) |> Repo.preload(:animals_image)
        page = Smartcitydogs.Repo.paginate(animals, page_size: 8)
        render(
          conn,
          "index.html",
          animals: page.entries,
          page: page,
          chip_number: params["chip_number"]
        )
    end
  end

  def new(conn, _params) do
    changeset = Animals.changeset(%Animals{})
   
    if conn.assigns.current_user != nil do
      if conn.assigns.current_user.users_types_id != 5 do
        render(conn, SmartcitydogsWeb.ErrorView, "401.html")
      else
        render(conn, "new.html", changeset: changeset)
      end
    else
      render(conn, SmartcitydogsWeb.ErrorView, "401.html")
    end
  end

  ##Create a animal from the form
  def create(conn, %{"animals" => animal_params}) do
    map_procedures = %{
      "Кастрирано" => animal_params["Кастрирано"],
      "Обезпаразитено" => animal_params["Обезпаразитено"],
      "Ваксинирано" => animal_params["Ваксинирано"]
    }

    list_procedures = Enum.map(map_procedures, fn(x) -> 
      case x do 
        {_, "true"} -> DataAnimals.get_procedure_id_by_name(x)
        _ -> nil
      end 
    
    end)
    
    logged_user_type_id = conn.assigns.current_user.users_types.id

    if logged_user_type_id != 5 do
      render(conn, SmartcitydogsWeb.ErrorView, "401.html")
    else
      case DataAnimals.create_animal(animal_params) do
        {:ok, animal} ->
          upload_file(animal.id, conn)

          DataAnimals.insert_performed_procedure(list_procedures, animal.id)

          conn
          |> redirect(to: animal_path(conn, :index))

        {:error, changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end
  end

  ##Upload file when creating
  def upload_file(id, conn) do
    upload = Map.get(conn, :params)
    upload = Map.get(upload, "files")

    for n <- upload do
      [head] = n

      extension = Path.extname(head.filename)

      File.cp(
        head.path,
        "../smartcitydogs/assets/static/images/#{Map.get(head, :filename)}-profile#{extension}"
      )

      args = %{
        "url" => "images/#{Map.get(head, :filename)}-profile#{extension}",
        "animals_id" => "#{id}"
      }

      DataAnimals.create_animal_image(args)
    end
  end

  def show(conn, map) do
    id_map = map["id"]
    cond do 
      id_map == "send_email" ->
        send_email(conn,map)
      
      id_map == "new" ->
        new(conn,map)
      
      true ->
        id = String.to_integer(map["id"])
        animal = DataAnimals.get_animal(id)
        render(conn,"show.html",animals: animal)
    end
  end

  def edit(conn, %{"id" => id}) do
    animal = DataAnimals.get_animal(id)
    changeset = DataAnimals.change_animal(animal)
    logged_user_type_id = conn.assigns.current_user.users_types.id

    if logged_user_type_id == 1 || logged_user_type_id == 5 do
      render(conn, "edit.html", animals: animal, changeset: changeset)
    else
      render(conn, SmartcitydogsWeb.ErrorView, "401.html")
    end
  end

  def update(conn, %{"id" => id, "animals" => animal_params}) do
    animal = DataAnimals.get_animal(id)

    logged_user_type_id = conn.assigns.current_user.users_types.id

    if logged_user_type_id == 1 || logged_user_type_id == 5 do
      case DataAnimals.update_animal(animal, animal_params) do
        {:ok, animal} ->
          conn
          |> put_flash(:info, "Animal updated successfully.")
          |> redirect(to: animal_path(conn, :show, animal))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", animal: animal, changeset: changeset)
      end
    else
      render(conn, SmartcitydogsWeb.ErrorView, "401.html")
    end
  end
 
  def delete(conn, %{"id" => id}) do
    animal = DataAnimals.get_animal(id)

    with {:ok, %Animals{}} <- DataAnimals.delete_animal(animal) do
      send_resp(conn, :no_content, "")
    end
  end

end
