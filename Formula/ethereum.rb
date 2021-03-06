class Ethereum < Formula
  desc "Official Go implementation of the Ethereum protocol"
  homepage "https://ethereum.github.io/go-ethereum/"
  url "https://github.com/ethereum/go-ethereum/archive/v1.8.27.tar.gz"
  sha256 "45d264106991d0e2a4c34ac5d6539fc9460c768fc70588ea38a25f467039ece8"
  head "https://github.com/ethereum/go-ethereum.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles"
    cellar :any_skip_relocation
    sha256 "52461b891abac02d0f0c4a480c801e1723f70a530f13b3f278a2c69f4df5753f" => :mojave
    sha256 "58de68950620fc13da9ec8c3da574ad2ebc2b6aa1fe689fd115775c240e88b53" => :high_sierra
    sha256 "2a0a8fdc7e7d1d08443223f82e842f7136af579557f8e5add144828213924db2" => :sierra
    sha256 "737b0bfaeb99a3ded7ea07ca25f27cd5a2ec86b5a85ff314b395829712ef160b" => :x86_64_linux
  end

  depends_on "go" => :build

  def install
    ENV.O0 unless OS.mac? # See https://github.com/golang/go/issues/26487
    system "make", "all"
    bin.install Dir["build/bin/*"]
  end

  test do
    (testpath/"genesis.json").write <<~EOS
      {
        "config": {
          "homesteadBlock": 10
        },
        "nonce": "0",
        "difficulty": "0x20000",
        "mixhash": "0x00000000000000000000000000000000000000647572616c65787365646c6578",
        "coinbase": "0x0000000000000000000000000000000000000000",
        "timestamp": "0x00",
        "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
        "extraData": "0x",
        "gasLimit": "0x2FEFD8",
        "alloc": {}
      }
    EOS
    system "#{bin}/geth", "--datadir", "testchain", "init", "genesis.json"
    assert_predicate testpath/"testchain/geth/chaindata/000001.log", :exist?,
                     "Failed to create log file"
  end
end
