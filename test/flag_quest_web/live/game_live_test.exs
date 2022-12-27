defmodule FlagQuestWeb.FlagGameLiveTest do
  use FlagQuestWeb.ConnCase

  import Phoenix.LiveViewTest
  import FlagQuest.FlagsFixtures

  @create_attrs %{image: "some image", name: "some name"}
  @update_attrs %{image: "some updated image", name: "some updated name"}
  @invalid_attrs %{image: nil, name: nil}

  defp create_flag(_) do
    flag = game_fixture()
    %{flag: flag}
  end

  describe "Index" do
    setup [:create_flag]

    test "lists all flags", %{conn: conn, flag: flag} do
      {:ok, _index_live, html} = live(conn, ~p"/flags")

      assert html =~ "Listing Flags"
      assert html =~ flag.image
    end

    test "saves new flag", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/flags")

      assert index_live |> element("a", "New Flag") |> render_click() =~
               "New Flag"

      assert_patch(index_live, ~p"/flags/new")

      assert index_live
             |> form("#flag-form", flag: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#flag-form", flag: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/flags")

      assert html =~ "Flag created successfully"
      assert html =~ "some image"
    end

    test "updates flag in listing", %{conn: conn, flag: flag} do
      {:ok, index_live, _html} = live(conn, ~p"/flags")

      assert index_live |> element("#flags-#{flag.id} a", "Edit") |> render_click() =~
               "Edit Flag"

      assert_patch(index_live, ~p"/flags/#{flag}/edit")

      assert index_live
             |> form("#flag-form", flag: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#flag-form", flag: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/flags")

      assert html =~ "Flag updated successfully"
      assert html =~ "some updated image"
    end

    test "deletes flag in listing", %{conn: conn, flag: flag} do
      {:ok, index_live, _html} = live(conn, ~p"/flags")

      assert index_live |> element("#flags-#{flag.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#flag-#{flag.id}")
    end
  end

  describe "Show" do
    setup [:create_flag]

    test "displays flag", %{conn: conn, flag: flag} do
      {:ok, _show_live, html} = live(conn, ~p"/flags/#{flag}")

      assert html =~ "Show Flag"
      assert html =~ flag.image
    end

    test "updates flag within modal", %{conn: conn, flag: flag} do
      {:ok, show_live, _html} = live(conn, ~p"/flags/#{flag}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Flag"

      assert_patch(show_live, ~p"/flags/#{flag}/show/edit")

      assert show_live
             |> form("#flag-form", flag: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#flag-form", flag: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/flags/#{flag}")

      assert html =~ "Flag updated successfully"
      assert html =~ "some updated image"
    end
  end
end
