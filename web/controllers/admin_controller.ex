defmodule Welcome.AdminController do
  use Welcome.Web, :controller

  # import the :authorize plug from the AccessControl module
  import Openmaize.AccessControl

  alias Openmaize.Signup
  alias Welcome.Mailer
  alias Welcome.User

  plug :scrub_params, "user" when action in [:create]

  # only users with the admin role can access resources in this module
  plug :authorize, roles: ["admin"]

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"user" => %{"email" => email} = user_params}) do
    {key, link} = Signup.gen_token_link(email)
    changeset = User.auth_changeset(%User{}, user_params, key)

    case Repo.insert(changeset) do
      {:ok, _user} ->
        Mailer.ask_confirm(email, link)
        conn
        |> put_flash(:info, "User created successfully.")
        |> redirect(to: admin_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    Repo.delete(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: admin_path(conn, :index))
  end
end
