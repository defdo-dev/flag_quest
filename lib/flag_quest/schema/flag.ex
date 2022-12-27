defmodule FlagQuest.Schema.Flag do
  @moduledoc """
  The definition for the Flag Schema.

  The catalogue contains the `name` of the country flag
  and the `image` url.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime]
  schema "defdo_flags" do
    field :image, :string
    field :name, :string

    timestamps()
  end

  def new_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:image, :name])
    |> validate_required([:image, :name])
  end

  @doc false
  def changeset(flag, attrs) do
    flag
    |> cast(attrs, [:image, :name])
    |> validate_required([:image, :name])
  end
end
