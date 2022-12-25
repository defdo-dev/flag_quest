defmodule FlagQuest.Repo do
  use Ecto.Repo,
    otp_app: :flag_quest,
    adapter: Ecto.Adapters.Postgres
end
