class Itertools < Formula
  desc "Simple XXX for C++"
  homepage "https://github.com/TRIQS/itertools"
  url "https://github.com/TRIQS/itertools/archive/refs/tags/1.2.0.tar.gz"
  sha256 "1e4d08d1f131e7283f031cf936cf25857490563d290249abc2d825813f5bb4bf"
  license "Apache-2.0"
  head "https://github.com/TRIQS/itertools.git", branch: "unstable"

  depends_on "cmake" => :build
  depends_on "llvm" => :build
  depends_on "ninja" => :build

  def install
    args = %W[
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DBuild_Tests=OFF
    ]

    ENV["CC"] = Formula["llvm"].opt_bin/"clang"
    ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "false"
  end
end
