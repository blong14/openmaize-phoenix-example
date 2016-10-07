defmodule Welcome.OpenmaizeEcto do
  @moduledoc """
  Functions to help with the interaction between Ecto and Openmaize.

  ## User model

  The example schema below is the most basic setup for Openmaize
  (:username and :password_hash are configurable):

      schema "users" do
        field :username, :string
        field :password, :string, virtual: true
        field :password_hash, :string

        timestamps()
      end

  In the example above, the ':username' is used to identify the user. This can
  be set to any other value, such as ':email'. See the documentation for
  Openmaize.Login for details about logging in with a different value.

  See the documentation for Openmaize.Config for details about configuring
  the ':password_hash' value.

  The ':password' and the ':password_hash' fields are needed for the
  'add_password_hash' function in this module. Note the addition of
  'virtual: true' to the definition of the password field. This means
  that it will not be stored in the database.
  """

  import Ecto.Changeset
  alias Welcome.{Repo, User}
  alias Openmaize.{Config, Password}

  @behaviour Openmaize.Database

  @doc """
  Find the user in the database.
  """
  def find_user(user_id, uniq) do
    Repo.get_by(User, [{uniq, user_id}])
  end

  @doc """
  Find the user, using the user id, in the database.
  """
  def find_user_by_id(id) do
    Repo.get(User, id)
  end

  @doc """
  Hash the password and add it to the user model or changeset.

  Before the password is hashed, it is checked to make sure that
  it is not too weak. See the documentation for the Openmaize.Password
  module for more information about the options available.

  This function will return a changeset. If there are any errors, they
  will be added to the changeset.

  Comeonin.Bcrypt is the default hashing function, but this can be changed to
  Comeonin.Pbkdf2, or any other algorithm, by setting the Config.crypto_mod value.
  """
  def add_password_hash(user, params) do
    (params[:password] || params["password"])
    |> Password.valid_password?(Config.password_strength)
    |> add_hash_changeset(user)
  end

  @doc """
  Add a confirmation token to the user model or changeset.

  Add the following three entries to your user schema:

      field :confirmation_token, :string
      field :confirmation_sent_at, Ecto.DateTime
      field :confirmed_at, Ecto.DateTime

  ## Examples

  In the following example, the 'add_confirm_token' function is called with
  a key generated by 'Openmaize.ConfirmEmail.gen_token_link':

      changeset
      |> Welcome.OpenmaizeEcto.add_confirm_token(key)

  """
  def add_confirm_token(user, key) do
    change(user, %{confirmation_token: key,
      confirmation_sent_at: Ecto.DateTime.utc})
  end

  @doc """
  Add a reset token to the user model or changeset.

  Add the following two entries to your user schema:

      field :reset_token, :string
      field :reset_sent_at, Ecto.DateTime

  As with 'add_confirm_token', the function 'Openmaize.ConfirmEmail.gen_token_link'
  can be used to generate the token and link.
  """
  def add_reset_token(user, key) do
    change(user, %{reset_token: key, reset_sent_at: Ecto.DateTime.utc})
  end

  @doc """
  Change the 'confirmed_at' value in the database to the current time.
  """
  def user_confirmed(user) do
    change(user, %{confirmed_at: Ecto.DateTime.utc})
    |> Repo.update
  end

  @doc """
  Add the password hash for the new password to the database.

  If the update is successful, the reset_token and reset_sent_at
  values will be set to nil.
  """
  def password_reset(user, password) do
    Password.valid_password?(password, Config.password_strength)
    |> reset_update_repo(user)
  end

  @doc """
  Function used to check if a token has expired.
  """
  def check_time(nil, _), do: false
  def check_time(sent_at, valid_secs) do
    (sent_at |> Ecto.DateTime.to_erl
     |> :calendar.datetime_to_gregorian_seconds) + valid_secs >
    (:calendar.universal_time |> :calendar.datetime_to_gregorian_seconds)
  end

  defp add_hash_changeset({:ok, password}, user) do
    change(user, %{Config.hash_name =>
      Config.crypto_mod.hashpwsalt(password)})
  end
  defp add_hash_changeset({:error, message}, user) do
    change(user, %{password: ""}) |> add_error(:password, message)
  end

  defp reset_update_repo({:ok, password}, user) do
    Repo.transaction(fn ->
      user = change(user, %{Config.hash_name =>
        Config.crypto_mod.hashpwsalt(password)})
      |> Repo.update!

      change(user, %{reset_token: nil, reset_sent_at: nil})
      |> Repo.update!
    end)
  end
  defp reset_update_repo({:error, message}, _user) do
    {:error, message}
  end
end
