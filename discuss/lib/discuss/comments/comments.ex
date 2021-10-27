defmodule Discuss.Comments do
  alias Discuss.Comments.Comment
  alias Discuss.Repo

  def add_comment_to_topic(content, topic, user_id) do
    changeset = topic
      |> Ecto.build_assoc(:comments, user_id: user_id)
      |> Comment.changeset(%{content: content})

    case Repo.insert(changeset) do
      {:ok, comment} ->
        {:ok, Repo.preload(comment, :user)} # return a new comment and preload associated user
      {:error, reason} ->
        {:error, reason}
    end
  end

end
