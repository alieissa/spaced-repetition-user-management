defmodule Users.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :password, :string
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :verified, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(user, %{verified: true} = attrs), do: cast(user, attrs, [:verified])

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:password, :email, :first_name, :last_name])
    |> validate_required([:password, :email])
    |> validate_format(:email, ~r/^[A-Za-z0-9._%+\-+']+@[A-Za-z0-9.-]+\.[A-Za-z]+$/,
      message: "Invalid email format"
    )
    |> unique_constraint(:email)
    |> hash_password()
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Bcrypt.hash_pwd_salt(password))
  end

  defp hash_password(changeset), do: changeset
end
