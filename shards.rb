require "formula"

class Shards < Formula
  homepage "https://github.com/ysbaddaden/shards"
  head "https://github.com/ysbaddaden/shards.git"
  url "https://github.com/ysbaddaden/shards/archive/v0.5.0.tar.gz"
  sha256 "9a365b4f1f7f53b2f00ac24ac6165cf11fa928941d181dac175f9c3bbbf29268"

  depends_on "crystal-lang" => :build

  def install
    system "crystal", "build", "-o", "bin/shards", "src/shards.cr", "--release"
    prefix.install "bin"
  end
end
