require "formula"

class Shards < Formula
  homepage "https://github.com/ysbaddaden/shards"
  head "https://github.com/ysbaddaden/shards.git"
  url "https://github.com/ysbaddaden/shards/archive/v0.5.1.tar.gz"
  sha256 "95916792766e42e3b005b144190c3f88d5cb8bcbaaddeb8fa8ced8bac1ef424d"
  depends_on "crystal-lang" => :build

  def install
    system "crystal", "build", "-o", "bin/shards", "src/shards.cr", "--release"
    prefix.install "bin"
  end
end
