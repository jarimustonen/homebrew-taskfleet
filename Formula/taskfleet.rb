class Taskfleet < Formula
  desc "Taskfleet CLI for orchestrating AI-agent workflows on a developer's machine."
  homepage "https://github.com/jarimustonen/taskfleet"
  version "0.18.0"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jarimustonen/taskfleet/releases/download/v0.18.0/taskfleet-aarch64-apple-darwin.tar.xz"
    sha256 "44b4f790e2e3187b13b9f60da243519349a4378aa39ffb6aff018ba5d8342210"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/taskfleet/releases/download/v0.18.0/taskfleet-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2e29e0750f5d950e9862d4815c604a60bb6db119c4f86b03059f291b5a9fa6ac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/taskfleet/releases/download/v0.18.0/taskfleet-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6f2a8ffe6a7fb112d411ef960b3b2b36318d504bdde0a1b2d6ba7cb71282be37"
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
