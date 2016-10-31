defmodule Welcome.User do
  use Welcome.Web, :model

  alias Openmaize.Database, as: DB

  schema "users" do
    field :username, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :confirmed_at, Ecto.DateTime
    field :confirmation_token, :string
    field :confirmation_sent_at, Ecto.DateTime
    field :reset_token, :string
    field :reset_sent_at, Ecto.DateTime

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:username, :email])
    |> validate_required([:username, :email])
    |> unique_constraint(:username)
  end

  def auth_changeset(struct, params, key) do
    struct
    |> changeset(params)
    |> DB.add_password_hash(params)
    |> DB.add_confirm_token(key)
  end

  def reset_changeset(struct, params, key) do
    struct
    |> cast(params, [:email], [])
    |> DB.add_reset_token(key)
  end
end
