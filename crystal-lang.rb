require 'formula'

CRYSTAL_VERSION = "0.8.0"
CRYSTAL_SHA = "5a16826145a846da3548e875cf104bdfc04c35cd6628cf66487de1bfbe9c5faf"

class CrystalLang < Formula
  homepage 'http://crystal-lang.org/'
  version CRYSTAL_VERSION
  conflicts_with 'crystal'

  stable do
    url "https://github.com/manastech/crystal/releases/download/#{CRYSTAL_VERSION}/crystal-#{CRYSTAL_VERSION}-1-darwin-x86_64.tar.gz"
    sha256 CRYSTAL_SHA
  end

  # head do
  #   url 'http://github.com/manastech/crystal.git'

  #   resource 'latest' do
  #     url 'http://crystal-lang.s3.amazonaws.com/crystal-darwin-latest.tar.gz'
  #   end
  # end

  depends_on "llvm" => :optional
  depends_on "libpcl" => :recommended
  depends_on "pkg-config"

  def install
    # if build.head?
    #   resource('latest').stage do
    #     (prefix/"deps").install "bin/crystal-exe" => "crystal"
    #   end

    #   script_root = %Q(INSTALL_DIR="#{prefix}")
    # end

    script_root = %Q(INSTALL_DIR="#{prefix}")
    inreplace('bin/crystal') do |s|
      s.gsub! /INSTALL_DIR=.+/, script_root
    end

    if build.with?('llvm') || Formula["llvm"].installed?
      inreplace('bin/crystal') do |s|
        if s =~ /export PATH="(.*)"/
          llvm_path = Formula["llvm"].opt_prefix
          s.gsub! /export PATH="(.*)"/, %(export PATH="#{llvm_path}/bin:#{$1}")
        end
      end
    end

    prefix.install Dir["*"]

    # zsh_completion.install "etc/completion.zsh" => "_crystal"
  end

  def post_install
    resource('latest').clear_cache if build.head?
  end
end
