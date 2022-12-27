# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     FlagQuest.Repo.insert!(%FlagQuest.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
defmodule Seeds.Flags do
  @flags_domain "www.worldometers.info"

  def extract_country_details(html) do
    [path | _] = Floki.find(html, "a") |> Floki.attribute("href")
    image = "https://#{@flags_domain}/#{path}"

    name = Floki.find(html, "div > div") |> Floki.text() |> String.trim()
    now = DateTime.utc_now() |> DateTime.truncate(:second)

    %{image: image, name: name, inserted_at: now, updated_at: now}
  end

  def get_country_flags do
    {:ok, _pid} = Finch.start_link(name: FlagClient)
    {:ok, %{body: body}} = Finch.build(:get, "https://www.worldometers.info/geography/flags-of-the-world/")
      |> Finch.request(FlagClient)
    {:ok, html} = Floki.parse_document(body)
    Floki.find(html, ".col-md-4 > div[align='center']")
  end

  def get_input(data) when is_list(data) do
    Enum.map(data, &extract_country_details/1)
  end

  def seed_db do
    html_country_flags = get_country_flags()
    flags = get_input(html_country_flags)

    FlagQuest.Repo.insert_all(FlagQuest.Schema.Flag, flags)
  end
end

Seeds.Flags.seed_db()
