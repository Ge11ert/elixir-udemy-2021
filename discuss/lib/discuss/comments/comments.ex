defmodule Discuss.Comments do
  alias Discuss.Comments.Comment
  alias Discuss.Repo

  def add_comment_to_topic(content, topic) do
    changeset = topic
      |> Ecto.build_assoc(:comments)
      |> Comment.changeset(%{content: content})

    Repo.insert(changeset)
  end

end
