defmodule Smartcitydogs.DataUsers do
  import Ecto.Query, warn: false
  alias Smartcitydogs.Repo

  alias Smartcitydogs.User
  alias Smartcitydogs.UserType
  alias Smartcitydogs.Contact

  def list_users do
    Repo.all(User) |> Repo.preload(:user_type)
  end

  def get_user!(id) do
    Repo.get!(User, id) |> Repo.preload(:user_type)
  end

  def get_user_by_email!(email) do
    Repo.get_by(User, email: email)
  end

  def create_user(args \\ %{}) do
    %User{}
    |> User.changeset(args)
    |> Repo.insert()
  end

  # def create_user_contact(id, args) do
  #   Repo.get!(User, id)
  #   |> Ecto.Changeset.change()
  #   |> Ecto.Changeset.put_embed( :contact, args)
  #   |> Repo.update!().contact
  #   Repo.get!(User, id)
  # end

  # todo: some users don't have phone
  def create_user_from_auth(auth) do
    create_user(%{
      username: auth.info.email,
      password_hash: "pass",
      first_name: String.split(auth.info.name, " ") |> List.first(),
      last_name: String.split(auth.info.name, " ") |> List.first(),
      email: auth.info.email,
      phone: "0000000000000",
      user_type_id: 1
    })
  end

  def update_user(%User{} = user, args) do
    user
    |> User.changeset(args)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def get_likes(signal_id) do
    Repo.one(
      from(l in Smartcitydogs.SignalLike, select: count(l.id), where: l.signal_id == ^signal_id)
    )
  end

  def add_liked_signal_comment(user_id, comment_id) do
    user = Repo.get!(User, user_id)

    User.changeset(user, %{liked_comments: user.liked_comments ++ [comment_id]})
    |> Repo.update()
  end

  def add_disliked_signal_comment(user_id, comment_id) do
    user = Repo.get!(User, user_id)

    User.changeset(user, %{disliked_comments: user.disliked_comments ++ [comment_id]})
    |> Repo.update()
  end

  def remove_liked_signal_comment(user_id, comment_id) do
    user = Repo.get!(User, user_id)

    User.changeset(user, %{liked_comments: user.liked_comments -- [comment_id]})
    |> Repo.update()
  end

  def remove_disliked_signal_comment(user_id, comment_id) do
    user = Repo.get!(User, user_id)

    User.changeset(user, %{disliked_comments: user.disliked_comments -- [comment_id]})
    |> Repo.update()
  end

  # Users types functions

  def list_users_types do
    Repo.all(UserType)
  end

  def create_user_type(args \\ %{}) do
    %UserType{}
    |> UserType.changeset(args)
    |> Repo.insert()
  end

  def get_user_type(id) do
    Repo.get!(UserType, id)
  end

  def update_users_type(%UserType{} = users_type, args) do
    users_type
    |> UserType.changeset(args)
    |> Repo.update()
  end

  def delete_user_type(%UserType{} = users_type) do
    Repo.delete(users_type)
  end

  def change_user_type(%UserType{} = users_type) do
    UserType.changeset(users_type, %{})
  end

  # Contact functions
  def list_contacts do
    Repo.all(Contact)
  end

  def get_contact!(id), do: Repo.get!(Contact, id)

  def create_contact(attrs \\ %{}) do
    %Contact{}
    |> Contact.changeset(attrs)
    |> Repo.insert()
  end

  def delete_contact(%Contact{} = contact) do
    Repo.delete(contact)
  end

  def change_contact(%Contact{} = contact) do
    Contact.changeset(contact, %{})
  end

  def authenticate_user(email, password) do
    query = from(u in User, where: u.email == ^email)
    query |> Repo.one() |> verify_password(password)
  end

  defp verify_password(nil, _) do
    # Perform a dummy check to make user enumeration more difficult
    Bcrypt.no_user_verify()
    {:error, "Wrong email or password"}
  end

  defp verify_password(user, password) do
    if Bcrypt.verify_pass(password, user.password_hash) do
      {:ok, user}
    else
      {:error, "Wrong email or password"}
    end
  end
end
