require "formula"

class Shards < Formula
  homepage "https://github.com/ysbaddaden/shards"
  head "https://github.com/ysbaddaden/shards.git"
  url "https://github.com/ysbaddaden/shards/archive/v0.5.3.tar.gz"
  sha256 "33a42709dc7f69b892f551b6a2d44b49d9d75b6e54e186fcb7534c8485f90139"

  depends_on "crystal-lang" => :build

  def install
    system "crystal", "build", "-o", "bin/shards", "src/shards.cr", "--release"
    prefix.install "bin"
  end
end
