defmodule DiscussWeb.CommentsChannel do
  use DiscussWeb, :channel

  alias Discuss.Topics
  alias Discuss.Comments

  def join("comments:" <> topic_id, params, socket) do
    topic_id = String.to_integer(topic_id)
    topic = Topics.get_topic(%{"id" => topic_id})
    {:ok, %{}, assign(socket, :topic, topic)}
  end

  def handle_in(name, %{"content" => content}, socket) do
    topic = socket.assigns.topic

    case Comments.add_comment_to_topic(content, topic) do
      {:ok, comment} ->
        {:reply, :ok, socket}
      {:error, _reason} ->
        {:reply, {:error, %{}}, socket}
    end
  end
end
