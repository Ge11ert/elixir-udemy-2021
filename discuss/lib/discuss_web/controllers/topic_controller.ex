defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller

  def new(conn, params) do
    IO.puts "Conn"
    IO.inspect conn
    IO.puts "Params"
    IO.inspect params
    render(conn, "new-topic.html")
  end
end
