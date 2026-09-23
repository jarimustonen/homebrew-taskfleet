class Taskfleet < Formula
  desc "Taskfleet CLI for orchestrating AI-agent workflows on a developer's machine."
  homepage "https://github.com/jarimustonen/taskfleet"
  version "0.11.1"
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/jarimustonen/taskfleet/releases/download/v0.11.1/taskfleet-aarch64-apple-darwin.tar.xz"
    sha256 "f838cc70b7487ef8f2916ae8356edc0f47c04e05efa13010f8fa179171d48103"
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/jarimustonen/taskfleet/releases/download/v0.11.1/taskfleet-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "48a3f79d602fa5f1111d8809b156376ac92489427693860115a9b2e58059155e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/jarimustonen/taskfleet/releases/download/v0.11.1/taskfleet-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "296ccb8b0bf2c3888d81f69f12544d8d01e7a6da3b14939fbfa9fc7cebd6ec87"
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
