defmodule FlagQuest.FlagsTest do
  use FlagQuest.DataCase

  alias FlagQuest.Flags

  describe "flags" do
    alias FlagQuest.Schema.Flag

    import FlagQuest.FlagsFixtures

    @invalid_attrs %{image: nil, name: nil}

    test "list_flags/0 returns all flags" do
      assert 195 == Flags.list_flags() |> length()
    end

    test "get_flag!/1 returns the flag with given id" do
      flag = game_fixture()
      assert Flags.get_flag!(flag.id) == flag
    end

    test "create_flag/1 with valid data creates a flag" do
      valid_attrs = %{image: "some image", name: "some name"}

      assert {:ok, %Flag{} = flag} = Flags.create_flag(valid_attrs)
      assert flag.image == "some image"
      assert flag.name == "some name"
    end

    test "create_flag/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Flags.create_flag(@invalid_attrs)
    end

    test "update_flag/2 with valid data updates the flag" do
      flag = game_fixture()
      update_attrs = %{image: "some updated image", name: "some updated name"}

      assert {:ok, %Flag{} = flag} = Flags.update_flag(flag, update_attrs)
      assert flag.image == "some updated image"
      assert flag.name == "some updated name"
    end

    test "update_flag/2 with invalid data returns error changeset" do
      flag = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Flags.update_flag(flag, @invalid_attrs)
      assert flag == Flags.get_flag!(flag.id)
    end

    test "delete_flag/1 deletes the flag" do
      flag = game_fixture()
      assert {:ok, %Flag{}} = Flags.delete_flag(flag)
      assert_raise Ecto.NoResultsError, fn -> Flags.get_flag!(flag.id) end
    end

    test "change_flag/1 returns a flag changeset" do
      flag = game_fixture()
      assert %Ecto.Changeset{} = Flags.change_flag(flag)
    end
  end
end
