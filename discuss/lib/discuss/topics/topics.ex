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

  def create_topic(%{"topic" => topic}, user) do
    changeset = user
      |> Ecto.build_assoc(:topics)
      |> Topic.changeset(topic)

    Repo.insert(changeset)
  end

  def get_topic_changeset(%{"id" => topic_id}) do
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)
    [topic: topic, changeset: changeset]
  end

  def get_topic(%{"id" => topic_id}) do
    Repo.get(Topic, topic_id)
  end

  def get_topic!(%{"id" => topic_id}) do
    Repo.get!(Topic, topic_id)
  end

  def get_topic_with_comments(%{"id" => topic_id}) do
    get_topic(%{"id" => topic_id})
    |> Repo.preload(comments: [:user]) # Preloads all associations on the given struct with all nested associations
  end

  def update_topic(%{"id" => topic_id, "topic" => topic}) do
    old_topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(old_topic, topic)

    case Repo.update(changeset) do
      {:ok, topic} -> {:ok, topic}
      {:error, changeset} -> {:error, changeset, old_topic}
    end
  end

  def delete_topic!(%{"id" => topic_id}) do
    Repo.get!(Topic, topic_id) |> Repo.delete!
  end
end
