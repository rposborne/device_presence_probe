defmodule Watch do
  use GenServer

  @url "http://localhost:4000/api/devices/scan"
  @probe_id  1

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Process.send_after(self(), :work, 1 * 60 * 60 * 50) # In 2 seconds
    {:ok, state}
  end

  def handle_info(:work, state) do
    # Do the work you desire here
    IO.puts "Running Arp Scan"
    json_payload = %{collector_id: @probe_id, devices: ArpScanner.scan } |> Poison.encode!
    HTTPoison.post!(@url, json_payload, [{"content-type", "application/json"}])
    # Start the timer again
    Process.send_after(self(), :work, 1 * 60 * 60 * 50) # In 1 minute

    {:noreply, state}
  end
end
