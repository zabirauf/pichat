defmodule PiChat.PageController do
  use PiChat.Web, :controller

  plug :action

  def index(conn, _params) do
    render conn, "index.html"
  end
end
