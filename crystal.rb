require 'formula'

class Crystal < Formula
  homepage 'http://crystal-lang.org/'

  stable do
    url 'http://crystal-lang.s3.amazonaws.com/crystal-darwin-0.3.0-p0.tar.gz'
    sha1 'd95f4ddf53fe54f25a3254634fde23ae3394e85b'
  end

  head do
    url 'http://github.com/manastech/crystal.git'

    resource 'latest' do
      url 'http://crystal-lang.s3.amazonaws.com/crystal-darwin-latest.tar.gz'
    end
  end

  depends_on "llvm33" => %w(with-clang all-targets)
  depends_on "bdw-gc"
  depends_on "libtask"

  def install
    if build.head?
      resource('latest').stage do
        (prefix/"deps").install "bin/crystal-exe" => "crystal"
      end

      script_root = %Q(SCRIPT_ROOT="#{prefix}")
    else
      script_root = %Q(SCRIPT_ROOT="#{prefix}/bin")
    end

    inreplace('bin/crystal') do |s|
      s.gsub! /SCRIPT_ROOT=.+/, script_root
    end

    prefix.install Dir["*"]
  end

  def post_install
    resource('latest').clear_cache if build.head?
  end
end
