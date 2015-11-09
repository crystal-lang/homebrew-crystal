class CrystalLang < Formula
  desc "Fast and statically typed, compiled language with Ruby-like syntax"
  homepage "http://crystal-lang.org/"
  url "https://github.com/manastech/crystal/archive/0.9.1.tar.gz"
  sha256 "b6e04c9ec5f4bb2235211c635eb7da7522113cd0f4c3410cdd07bb3ae0de0c38"
  head "https://github.com/manastech/crystal.git"

  resource "boot" do
    url "https://github.com/manastech/crystal/releases/download/0.9.0/crystal-0.9.0-1-darwin-x86_64.tar.gz"
    sha256 "fd670b01dfa35805c8c57126dabebfe25c0942b673d9b3c6d5116d8b3f5ba53a"
  end

  resource "shards" do
    url "https://github.com/ysbaddaden/shards/archive/v0.5.3.tar.gz"
    sha256 "33a42709dc7f69b892f551b6a2d44b49d9d75b6e54e186fcb7534c8485f90139"
  end

  option "without-release", "Do not build the compiler in release mode"
  option "without-shards", "Do not include `shards` dependency manager"

  depends_on "libevent"
  depends_on "libpcl"
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
      system "make", "llvm_ext"
      (buildpath/".build").mkpath
      system "bin/crystal", "build", "-o", ".build/crystal", "src/compiler/crystal.cr"
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
