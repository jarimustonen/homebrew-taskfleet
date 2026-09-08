class Taskfleet < Formula
  desc "Taskfleet CLI for orchestrating AI-agent workflows on a developer's machine."
  homepage "https://github.com/jarimustonen/taskfleet"
  version "0.8.2"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jarimustonen/taskfleet/releases/download/v0.8.2/taskfleet-aarch64-apple-darwin.tar.xz"
    sha256 "d60f8d7a56e4501ddd210f329a3252c6e53c35357e46ac228fce38d6c2b061aa"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/taskfleet/releases/download/v0.8.2/taskfleet-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "978f4dffd16e7571f83c5e9a3e70e3009cd7d72385b9f5d6c713805f29c75ffd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/taskfleet/releases/download/v0.8.2/taskfleet-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fffea5f4242335c574dba572fdc40776d4fa00d5475582ef93c4143b2b692937"
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
