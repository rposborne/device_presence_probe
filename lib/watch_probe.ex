defmodule Watch do
  use GenServer

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

  def key do
    System.get_env("WHITETOWER_API_KEY")
  end

  def url do
    System.get_env("WHITETOWER_URL")
  end

  def scan do
    IO.puts "Running Arp Scan"
    IO.puts "Connecting to #{url} as #{key}"

    json_payload = %{devices: ArpScanner.scan } |> Poison.encode!

    HTTPoison.post(
      url,
      json_payload,
      [
        {"content-type", "application/json"},
        {"authorization", "token #{key}"}
      ]
    )
  end
end
