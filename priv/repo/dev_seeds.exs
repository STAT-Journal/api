alias Stat.Repo
alias Stat.Accounts
alias Stat.Accounts.User
alias Stat.Posts.Moment

defmodule Utils do
  def rand_good_or_bad() do
    if :rand.uniform() > 0.5 do
      :good
    else
      :bad
    end
  end
end

Repo.delete_all(User)

user_one = %User{}
|> User.registration_changeset(%{email: "one@example.com"})
|> Repo.insert()

user_one |> Accounts.confirm_user()

user_two = %User{}
|> User.registration_changeset(%{email: "two@example.com"})
|> Repo.insert()

user_two |> Accounts.confirm_user()

Repo.delete_all(Moment)

Enum.to_list(1..10)
|> Enum.map(fn i ->
  Process.sleep(1000)
  %Moment{}
  |> Moment.changeset(%{
    user_id: user_one |> elem(1) |> Map.get(:id),
    type: Utils.rand_good_or_bad(),
  })
  |> Repo.insert!()
end)

Enum.to_list(1..10)
|> Enum.map(fn i ->
  Process.sleep(1000)
  %Moment{}
  |> Moment.changeset(%{
    user_id: user_two |> elem(1) |> Map.get(:id),
    type: Utils.rand_good_or_bad(),
  })
  |> Repo.insert!()
end)

IO.inspect(user_one)
IO.inspect(user_two)
