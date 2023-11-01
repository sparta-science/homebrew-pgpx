class Pgpx < Formula
  desc "Port monitoring tool that proxies traffic between a client and the tunnel"
  homepage "https://github.com/sparta-science/homebrew-pgpx"
  version "0.0.2"
  license "MPL-2.0"

  if Hardware::CPU.arm?
    url "https://github.com/sparta-science/homebrew-pgpx/releases/download/v#{version}/pgpx-darwin-arm64"
    sha256 "0c75a22d2f4194e04b53d78e1eb21fef5468e548bd243c8b565c224b6d551c20"
  else
    url "https://github.com/sparta-science/homebrew-pgpx/releases/download/v#{version}/pgpx-darwin-amd64"
    sha256 "0f0b4055bfd79f5116ecad37dc001811ed24c7a25d6ebeae7262761c3c8d3239"
  end

  def install
    bin.install "pgpx-#{Hardware::CPU.arm? ? "darwin-arm64" : "darwin-amd64"}" => "pgpx"
  end

  test do
    assert_match "pgpx version v#{version}", shell_output("#{bin}/pgpx --version")
  end
end
