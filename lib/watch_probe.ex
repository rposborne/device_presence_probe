defmodule Watch do
  use GenServer
  @probe_id  1

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    scan
    Process.send_after(self(), :work, 1 * 60 * 60 * 50) # In 2 seconds
    {:ok, state}
  end

  def handle_info(:work, state) do
    # Do the work you desire here
    # Start the timer again
    scan
    Process.send_after(self(), :work, 1 * 60 * 60 * 50) # In 1 minute

    {:noreply, state}
  end

  def scan do
    IO.puts "Running Arp Scan"
    IO.puts "Connecting to #{System.get_env("WHITETOWER_URL")}"
    json_payload = %{devices: ArpScanner.scan } |> Poison.encode!
    HTTPoison.post(
      System.get_env("WHITETOWER_URL"),
      json_payload,
      [{"content-type", "application/json"}, {"authentication", "token #{System.get_env("WHITETOWER_API_KEY")}"}])
    IO.puts "Running Arp Scan"
  end
end
