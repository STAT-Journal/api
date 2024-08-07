defmodule Stat.Jobs.ContentProcessing do
  use Oban.Worker, queue: :content_processing

  def do_work(%Oban.Job{args: %{"id" => id, "type" => "text"} = args}) do
    # Do the work
  end

  def do_work(%Oban.Job{args: %{"id" => id, "type" => "image"} = args}) do
    # Do the work
  end

  @impl true
  def perform(%Oban.Job{args: %{"id" => _id, "type" => _type} = args}) do
    do_work(%Oban.Job{args: args})
  end
end
