defmodule Stat.PeriodicConsumablesScheduler do
  import Ecto.Query, warn: false

  alias Stat.Repo
  # This module defines a background job that will
  # periodically give users consumables.

  use Quantum, otp_app: :stat

  def run do
    # This is where you would put the code to give users consumables.
    # For now, we'll just log a message.
    IO.puts("Giving users consumables")

    Repo.all(Stat.Accounts.User)
    |> Enum.map(fn user -> user.id end)
    |> Enum.each(&Stat.Consumables.give_random_sticker/1)
  end
end
