require 'formula'

class Crystal < Formula
  homepage 'http://crystal-lang.org/'

  stable do
    url 'http://crystal-lang.s3.amazonaws.com/crystal-darwin-0.3.5.tar.gz'
    sha1 '24b33880c77872afdbda334f9e79d4280915a760'
  end

  head do
    url 'http://github.com/manastech/crystal.git'

    resource 'latest' do
      url 'http://crystal-lang.s3.amazonaws.com/crystal-darwin-latest.tar.gz'
    end
  end

  depends_on "llvm33" => [:recommended, 'with-clang', 'all-targets']
  depends_on "bdw-gc"
  depends_on "libpcl" => :recommended

  patch :DATA

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

__END__
diff --git a/bin/crystal b/bin/crystal
index a3f6448..454983c 100755
--- a/bin/crystal
+++ b/bin/crystal
@@ -1,4 +1,4 @@
 #!/usr/bin/env bash
 SCRIPT_ROOT="$(dirname $(readlink $0 || echo $0))"
-export CRYSTAL_PATH="$SCRIPT_ROOT/../src:$SCRIPT_ROOT/../libs:libs"
+export CRYSTAL_PATH="src:libs:$SCRIPT_ROOT/../src:$SCRIPT_ROOT/../libs"
 "$SCRIPT_ROOT/crystal-exe" "$@"
