class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "http://crystal-lang.org/"
  url "https://github.com/crystal-lang/crystal/archive/0.19.0.tar.gz"
  sha256 "4d7d9770891bd8bd835251e2654316412a3f44074db0adeca28357c0993eb2d8"
  head "https://github.com/crystal-lang/crystal.git"

  resource "boot" do
    url "https://github.com/crystal-lang/crystal/releases/download/0.18.7/crystal-0.18.7-1-darwin-x86_64.tar.gz"
    version "0.18.7"
    sha256 "4b2806ff4f3073f2c13d9a3ca3700e2cbc0e4e4060a9af02f49e9c9131bc464e"
  end

  resource "shards" do
    url "https://github.com/ysbaddaden/shards/archive/v0.6.4.tar.gz"
    sha256 "5972f1b40bb3253319f564dee513229f82b0dcb8eea1502ae7dc483a9c6da5a0"
  end

  option "without-release", "Do not build the compiler in release mode"
  option "without-shards", "Do not include `shards` dependency manager"

  depends_on "libevent"
  depends_on "bdw-gc"
  depends_on "llvm" => :build
  depends_on "libyaml" if build.with?("shards")

  def install
    (buildpath/"boot").install resource("boot")

    if build.head?
      ENV["CRYSTAL_CONFIG_VERSION"] = `git rev-parse --short HEAD`.strip
    else
      ENV["CRYSTAL_CONFIG_VERSION"] = version
    end

    ENV["CRYSTAL_CONFIG_PATH"] = prefix/"src:libs"
    ENV.append_path "PATH", "boot/bin"

    if build.with? "release"
      system "make", "crystal", "release=true"
    else
      system "make", "deps"
      (buildpath/".build").mkpath
      system "bin/crystal", "build", "-o", "-D", "without_openssl", "-D", "without_zlib", ".build/crystal", "src/compiler/crystal.cr"
    end

    if build.with? "shards"
      resource("shards").stage do
        system buildpath/"bin/crystal", "build", "-o", buildpath/".build/shards", "src/shards.cr"
      end
      bin.install ".build/shards"
    end

    bin.install ".build/crystal"
    prefix.install "src"
  end

  test do
    system "#{bin}/crystal", "eval", "puts 1"
  end
end
