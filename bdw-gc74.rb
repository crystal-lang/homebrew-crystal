require 'formula'

class BdwGc74 < Formula
  homepage 'http://www.hboehm.info/gc/'
  url 'http://www.hboehm.info/gc/gc_source/gc-7.4.0.tar.gz'
  sha1 '82f031a5a6db004df3cf8f1b1e72dd6b313ab032'

  depends_on "libatomic_ops"
  depends_on 'pkg-config' => :build

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-cplusplus"
    system "make"
    system "make check"
    system "make install"
  end
end
