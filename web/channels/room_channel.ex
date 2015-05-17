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
    send(self, {:user_count, 0})
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
    # TODO: Decrement the count of user and broadcast
    send(self, {:user_count, 0})
    :ok
  end

  @doc """
  Handle new message from the user
  """
  def handle_in("new:msg", msg, socket) do
    broadcast! socket, "new:msg", %{user: msg["user"], body: msg["body"]}
    # TODO: Add the message to past messages

    {:reply, {:ok, msg["body"]}, assign(socket, :user, msg["user"])}
  end

  @doc """
  Broadcast the user count
  """
  def handle_info({:user_count, count}, socket) do
    # TODO: Broadcast the user count
    {:noreply, socket}
  end

  @doc """
  Send the user past N messages
  """
  def handle_info(:past_messages, socket) do
    # TODO: Send the user past N messages
    {:noreply, socket}
  end
end
