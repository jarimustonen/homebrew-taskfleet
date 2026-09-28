class Taskfleet < Formula
  desc "Taskfleet CLI for orchestrating AI-agent workflows on a developer's machine."
  homepage "https://github.com/jarimustonen/taskfleet"
  version "0.11.4"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jarimustonen/taskfleet/releases/download/v0.11.4/taskfleet-aarch64-apple-darwin.tar.xz"
    sha256 "871cd928c477bd92a139a6b247da730061892f1772760bc024eb8f1cc97b8780"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/taskfleet/releases/download/v0.11.4/taskfleet-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d4fa7ca8afe2e00c6c0366b10e17dc86e68825e0d7abada021c128ad020a87b6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/taskfleet/releases/download/v0.11.4/taskfleet-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6035d8ab3a943dfac045d626e21699e27e5aef07af40acde9c57786b906402bf"
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
