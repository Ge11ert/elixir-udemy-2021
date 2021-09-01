defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller
  plug Ueberauth

  def callback(conn, params) do
    IO.puts "AUTH CALLBACK START"
    IO.inspect conn.assigns
    IO.inspect params
    IO.puts "AUTH CALLBACK END"
  end
end
