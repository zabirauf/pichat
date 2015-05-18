defmodule PiChat.RoomChannel do
  use Phoenix.Channel
  require Logger

  @doc """
  Authorize user to subscribe and broadcast events on lobby channel
  """
  def join("rooms:lobby", _message, socket) do
    Process.flag(:trap_exit, true)

    # Broadcast user count and send the user past messages
    # TODO: Increment the user count and broadcast
    send(self, :broadcast_count)
    send(self, :past_messages)

    {:ok, socket}
  end

  @doc """
  Unauthorize user and don't subscribe it to any other topic than lobby
  """
  def join("rooms:" <> _private_subtopic, _message, _socket) do
    :ignore
  end

  @doc """
  The socket connection has been terminated, decrement the user count and broadcast
  """
  def terminate(reason, socket) do
    Logger.debug "> leave #{inspect reason}"
    broadcast! socket, "user:count", %{"count" => visitor_count(socket) - 1}
    :ok
  end

  @doc """
  Handle new message from the user
  """
  def handle_in("new:msg", msg, socket) do
    msg_content = %{user: msg["user"], body: msg["body"]}
    broadcast! socket, "new:msg", msg_content

    PiChat.MessageList.update(msg_content)

    {:reply, {:ok, msg["body"]}, assign(socket, :user, msg["user"])}
  end

  @doc """
  Broadcast the user count
  """
  def handle_info(:broadcast_count, socket) do
    broadcast! socket, "user:count", %{"count" => visitor_count(socket)}
    {:noreply, socket}
  end

  @doc """
  Send the user past N messages
  """
  def handle_info(:past_messages, socket) do
    past_messages = PiChat.MessageList.get
    Enum.each past_messages, &(push socket, "new:msg", &1)
    {:noreply, socket}
  end

  defp visitor_count(socket) do
    Enum.count Phoenix.PubSub.Local.subscribers(PiChat.PubSub.Local, socket.topic)
  end
end
