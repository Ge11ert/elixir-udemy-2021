defmodule Discuss.Topics do

  alias Discuss.Topics.Topic
  alias Discuss.Repo

  def get_all do
    Repo.all(Topic)
  end

  def get_new_changeset do
    %Topic{}
    |> Topic.changeset()
  end

  def create_topic(%{"topic" => topic}) do
    %Topic{}
    |> Topic.changeset(topic)
    |> Repo.insert()
  end
end
