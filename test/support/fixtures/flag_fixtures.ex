defmodule FlagQuest.FlagsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `FlagQuest.Flags` context.
  """

  @doc """
  Generate a flag.
  """
  def game_fixture(attrs \\ %{}) do
    {:ok, flag} =
      attrs
      |> Enum.into(%{
        image: "some image",
        name: "some name"
      })
      |> FlagQuest.Flags.create_flag()

    flag
  end
end
