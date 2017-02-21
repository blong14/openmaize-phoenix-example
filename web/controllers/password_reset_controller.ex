defmodule Welcome.PasswordResetController do
  use Welcome.Web, :controller

  import Welcome.Authorize
  alias Welcome.{Email, User}

  plug Openmaize.ResetPassword,
    [mail_function: &Email.receipt_confirm/1] when action in [:update]

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"password_reset" => %{"email" => email} = user_params}) do
    {key, link} = Openmaize.ConfirmEmail.gen_token_link(email)
    send_token(conn, Repo.get_by(User, email: email), user_params, {key, email, link})
  end

  def edit(conn, %{"email" => email, "key" => key}) do
    case Repo.get_by(User, email: email) do
      nil -> render conn, "new.html"
      user -> render conn, "edit.html", user: user, email: email, key: key
    end
  end

  def update(%Plug.Conn{private: %{openmaize_error: message}} = conn,
   %{"id" => user, "password_reset" => %{"email" => email, "key" => key}}) do
    conn
    |> put_flash(:error, message)
    |> render("edit.html", user: user, email: email, key: key)
  end
  def update(%Plug.Conn{private: %{openmaize_info: message}} = conn, _params) do
    configure_session(conn, drop: true) |> auth_info(message, session_path(conn, :new))
  end

  defp send_token(conn, nil, params, _) do
    render conn, "new.html"
  end
  defp send_token(conn, user, user_params, {key, email, link}) do
    changeset = User.reset_changeset(user, user_params, key)
    case Repo.update(changeset) do
      {:ok, _user} ->
        Email.ask_reset(email, link)
        message = "Check your inbox for instructions on how to reset your password"
        auth_info conn, message, user_path(conn, :index)
      {:error, _changeset} ->
        render conn, "new.html"
    end
  end
end
