class Taskfleet < Formula
  desc "Taskfleet CLI for orchestrating AI-agent workflows on a developer's machine."
  homepage "https://github.com/jarimustonen/taskfleet"
  version "0.17.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jarimustonen/taskfleet/releases/download/v0.17.1/taskfleet-aarch64-apple-darwin.tar.xz"
    sha256 "8a5ca59db0a9ab00185724e0bb8615f4c8e372ebdc5af8d3032e80f4d041835e"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/taskfleet/releases/download/v0.17.1/taskfleet-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7340da3cc8b9c98b53e902a526a38b67a4b9cab7f94372e098e6a04f05894374"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/taskfleet/releases/download/v0.17.1/taskfleet-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3a96ddf39426fd42aa926b2b4ff635ceb0932988719a0598ce956f185fd238bc"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    if OS.mac? && Hardware::CPU.arm?
      bin.install "taskfleet"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "taskfleet"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "taskfleet"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
