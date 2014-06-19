require 'formula'

class Crystal < Formula
  homepage 'http://crystal-lang.org'
  url 'http://crystal-lang.s3.amazonaws.com/crystal-darwin-0.1.0-p0.tar.gz'
  sha1 'fbbd7f817daa19a56c5c97128cd9c66c7e99b68c'

  depends_on "llvm33" => %w(with-clang all-targets)
  depends_on "manastech/crystal/bdw-gc"
  depends_on "libtask"

  def install
    inreplace('bin/crystal') do |s|
      s.gsub! /SCRIPT_ROOT=.+/, %Q(SCRIPT_ROOT="#{prefix}/bin")
    end

    prefix.install Dir["*"]
  end
end
