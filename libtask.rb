require 'formula'

class Libtask < Formula
  homepage 'http://swtch.com/libtask/'
  url 'http://swtch.com/libtask.tar.gz'
  sha1 '3873d8b53d386e7d6baecf99310ae3c3f6e8d066'
  version 'latest'

  def install
    inreplace 'Makefile', '/usr/local', prefix

    mkdir lib
    mkdir include

    system "make", "libtask.a"
    system "make", "install"
  end
end
