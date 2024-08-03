defmodule Stat.Jobs.Groups do
  @moduledoc """
  This task periodically reviews user activity and creates groups with users
  who have interacted in the same time frame.
  """
  alias Stat.Groups

  def create_groups() do
    Groups.create_groups()
  end

  def deactivate_groups() do
    Groups.deactivate_groups()
  end
end
