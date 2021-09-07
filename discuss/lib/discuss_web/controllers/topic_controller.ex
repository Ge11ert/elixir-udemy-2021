defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topics

  plug DiscussWeb.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]

  def index(conn, _params) do
    render(conn, "index.html", topics: Topics.get_all())
  end

  def new(conn, _params) do
    render(conn, "new.html", changeset: Topics.get_new_changeset())
  end

  def create(conn, params) do
    case Topics.create_topic(params) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic created")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} -> render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, params) do
    [topic: topic, changeset: changeset] = Topics.get_topic_changeset(params)
    render(conn, "edit.html", changeset: changeset, topic: topic)
  end

  def update(conn, params) do
    case Topics.update_topic(params) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic updated")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset, old_topic} -> render(conn, "edit.html", changeset: changeset, topic: old_topic)
    end
  end

  def delete(conn, params) do
    Topics.delete_topic!(params)

    conn
    |> put_flash(:info, "Topic deleted")
    |> redirect(to: Routes.topic_path(conn, :index))
  end
end
