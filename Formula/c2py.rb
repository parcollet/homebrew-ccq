class C2py < Formula
  desc "Clair/c2py"
  homepage "https://github.com/TRIQS/c2py"
  url "https://github.com/flatironinstitute/c2py/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "dbe28f89ff0c9091c874e0bcd10a686dd8f761eb6c0568e1f040a84b33f9f86d"
  license "Apache-2.0"
  head "https://github.com/TRIQS/c2py.git", branch: "unstable"

  depends_on "cmake" => [:build, :test]
  depends_on "fmt"=> :build
  depends_on "ninja" => [:build, :test]

  depends_on "llvm"
  depends_on "python@3.12" # automatic from llvm
  depends_on "numpy"

  def install
    args = %W[
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DBuild_Tests=ON
    ]

    ENV["CC"] = Formula["llvm"].opt_bin/"clang"
    ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  # TESTING
  test do
    system "ctest"
  end
end

# rm all ccq formula
# brew uninstall `brew list --full-name -1|grep ccq`
