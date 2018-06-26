defmodule SmartcitydogsWeb.ContactController do
  use SmartcitydogsWeb, :controller

  alias Smartcitydogs.User
  alias Smartcitydogs.Repo
  alias Smartcitydogs.DataUsers
  alias Smartcitydogs.Email

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset, action: contact_path(conn, :create))
  end

  def create(conn, %{"user" => user_params}) do
    topic = Map.get(user_params, "topic")
    text = Map.get(user_params, "text")

    Email.send_unauth_contact_email(topic, text, user_params)
    |> Smartcitydogs.Mailer.deliver_now()

    redirect(conn, to: page_path(conn, :index))
  end

  def edit(conn, %{"id" => id}) do
    user = DataUsers.get_user!(id)
    changeset = DataUsers.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    topic = Map.get(user_params, "topic")
    text = Map.get(user_params, "text")
    contact_map = [%Smartcitydogs.User.Contact{topic: topic, text: text}]
    user_sender = DataUsers.create_user_contact(id, contact_map)
    user_email = Map.get(user_sender, :email)

    Email.send_contact_email(user_sender, user_email)
    |> Smartcitydogs.Mailer.deliver_now()

    redirect(conn, to: page_path(conn, :index))
  end
end