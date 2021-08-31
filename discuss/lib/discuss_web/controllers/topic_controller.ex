defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topics.Topic
  alias Discuss.Repo

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"topic" => topic}) do
    # TODO: нужно переместить это в context, в Discuss.Topics
    changeset = Topic.changeset(%Topic{}, topic)
    case Repo.insert(changeset) do
      {:ok, post} -> render(conn, "new.html", post: post, changeset: changeset)
      {:error, changeset} -> render(conn, "new.html", changeset: changeset)
    end
  end
end
