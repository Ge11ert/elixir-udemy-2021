defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topics

  def index(conn, _params) do
    render(conn, "index.html", topics: Topics.get_all())
  end

  def new(conn, _params) do
    render(conn, "new.html", changeset: Topics.get_new_changeset())
  end

  def create(conn, params) do
    case Topics.create_topic(params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Topic created")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} -> render(conn, "new.html", changeset: changeset)
    end
  end
end
