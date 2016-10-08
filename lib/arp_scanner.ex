defmodule ArpScanner do
  def scan do
    {output, _exit_code} = System.cmd("arp-scan", ["--localnet", "--quiet"])

    output |> String.split("\n") |> extract_scan
  end

  def extract_scan(lines) do
    lines
    |> Enum.filter(fn line -> Regex.match?(~r/([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$/, line) end)
    |> Enum.map( fn line -> split_ip_and_mac(line) end)
  end

  def split_ip_and_mac(line) do
    [ip, mac] = String.split(line, "\t")

    %{ip: ip, mac_address: mac, seen_at: DateTime.utc_now}
  end
end