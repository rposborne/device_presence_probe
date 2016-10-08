defmodule Watch do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Process.send_after(self(), :work, 1 * 60 * 50) # In 2 seconds
    {:ok, state}
  end

  def handle_info(:work, state) do
    # Do the work you desire here
    IO.puts "Running Arp Scan"
    json_payload = ArpScanner.scan |> Poison.encode!
    HTTPoison.post!("http://requestb.in/13d6z091", json_payload)
    # Start the timer again
    Process.send_after(self(), :work, 1 * 60 * 50) # In 1 minute

    {:noreply, state}
  end
end
