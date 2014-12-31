require 'formula'

class Crystal < Formula
  homepage 'http://crystal-lang.org/'
  version '0.5.6'

  stable do
    url 'https://github.com/manastech/crystal/releases/download/0.5.6/crystal-0.5.6-1-darwin-x86_64.tar.gz'
    sha1 'd428f511621dead49a1996891bb0a8aaf3d5249f'
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
  end

  def post_install
    resource('latest').clear_cache if build.head?
  end
end
