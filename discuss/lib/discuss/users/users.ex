defmodule Discuss.Users do
  alias Discuss.Users.User
  alias Discuss.Repo

  def sign_user_in(user_params) do
    case is_user_exists?(user_params) do
      nil -> save_user(user_params)
      user -> update_user(user, user_params)
    end
  end

  def save_user(user_params) do
    changeset = User.changeset(%User{}, user_params)
    Repo.insert(changeset)
  end

  def update_user(user, _user_params) do
    {:ok, user}
  end

  defp is_user_exists?(user_params) do
    Repo.get_by(User, email: user_params.email)
  end
end
