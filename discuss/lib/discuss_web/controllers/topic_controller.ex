defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  alias Discuss.Topics

  plug DiscussWeb.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]
  plug :check_topic_owner when action in [:update, :edit, :delete]

  def index(conn, _params) do
    render(conn, "index.html", topics: Topics.get_all())
  end

  def new(conn, _params) do
    render(conn, "new.html", changeset: Topics.get_new_changeset())
  end

  def create(conn, params) do
    current_user = conn.assigns.user

    case Topics.create_topic(params, current_user) do
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

  def show(conn, params) do
    topic = Topics.get_topic!(params)
    render(conn, "show.html", topic: topic)
  end

  defp check_topic_owner(conn, _params) do
    %{params: conn_params, assigns: %{user: user}} = conn

    if Topics.get_topic(conn_params).user_id == user.id do
      conn
    else
      conn
      |> put_flash(:error, "You cannot edit that")
      |> redirect(to: Routes.topic_path(conn, :index))
      |> halt()
    end
  end
end
