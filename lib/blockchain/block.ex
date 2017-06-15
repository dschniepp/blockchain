defmodule Blockchain.Block do
  @moduledoc "Provides Block struct and related block operations"

  alias Blockchain.{Block, Chain}

  @mandatory_keys [
    :index,
    :previous_hash,
    :timestamp,
    :data
  ]

  # @enforce_keys @mandatory_keys --> this is causing issues with Poinson decoding
  @derive [Poison.Encoder]
  defstruct @mandatory_keys ++ [:hash]

  def genesis_block do
    b = %Block{
      index: 0,
      previous_hash: "0",
      timestamp: 1_465_154_705,
      data: "genesis block"
    }
    %{b | hash: compute_hash(b)}
  end

  def generate_next_block(data) do
    generate_next_block(data, Chain.latest_block)
  end

  def generate_next_block(data, %Block{} = latest_block) do
    b = %Block {
      index: latest_block.index + 1,
      previous_hash: latest_block.hash,
      timestamp: System.system_time(:second),
      data: data
    }
    %{b | hash: compute_hash(b)}
  end

  def compute_hash(%Block{index: i, previous_hash: h, timestamp: timestamp, data: data}) do
    hash = :crypto.hash(:sha256, "#{i}#{h}#{timestamp}#{data}")
    Base.encode16(hash)
  end

end
