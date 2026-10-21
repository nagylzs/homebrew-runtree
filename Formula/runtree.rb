class Runtree < Formula
  desc "Runs a tree of commands, each in its own terminal that you can step into"
  homepage "https://github.com/nagylzs/runtree"
  url "https://github.com/nagylzs/runtree/archive/refs/tags/v0.1.2.tar.gz"
  sha256 "b0d222c711a9d386cc6578fa7c82ad9b3cc5899920bfc178067cae5bebca6dd6"
  license "GPL-3.0-only"
  head "https://github.com/nagylzs/runtree.git", branch: "main"

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  uses_from_macos "python" => :build

  # The GUI (runtree) needs GTK 4 and VTE; on Linux, the formula has the programs without the GUI
  # (runtree-headless, rtrunner, runtree-lsp): use the packages of the distribution for the GUI there.
  on_macos do
    # the libraries that runtree (the GUI) links; gotk4 links libgirepository too
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "gettext"
    depends_on "glib"
    depends_on "gobject-introspection"
    depends_on "graphene"
    depends_on "gtk4"
    depends_on "harfbuzz"
    depends_on "pango"
    depends_on "socat"
    depends_on "vte3"
  end

  def install
    # the source tarball has no git: build.py takes the version from here
    ENV["RUNTREE_VERSION"] = "v#{version}" if build.stable?
    args = ["--no-debug", "--no-windows"]
    # on Linux the GUI would need a GTK 4 and VTE of Homebrew, next to the ones of the desktop
    args << "--no-gui" if OS.linux?
    system "python3", "scripts/build.py", *args
    os = OS.mac? ? "darwin" : "linux"
    arch = Hardware::CPU.arm? ? "arm64" : "amd64"
    bin.install Dir["dist/#{os}/#{arch}/*"]
  end

  test do
    assert_match(/^runtree-headless v\d/, shell_output("#{bin}/runtree-headless --version"))
    (testpath/"hello.rt.yaml").write <<~YAML
      tree:
        args: [echo, hello from runtree]
    YAML
    assert_match "OK", shell_output("#{bin}/runtree-headless --check #{testpath}/hello.rt.yaml 2>&1")
    assert_match "hello from runtree", shell_output("#{bin}/runtree-headless #{testpath}/hello.rt.yaml")
    assert_match(/^rtrunner v\d/, shell_output("#{bin}/rtrunner --version"))
    assert_match(/^runtree v\d/, shell_output("#{bin}/runtree --version")) if OS.mac?
  end
end
