class Clair < Formula
  desc "Clair/c2py"
  homepage "https://github.com/TRIQS/c2py"
  # url "https://github.com/TRIQS/nda/archive/refs/tags/1.2.0.tar.gz"
  # sha256 "e054ff73512b9c43ca8c0b5036629ecf6179befd5b6b9579b963d683be377c89"
  license "Apache-2.0"
  head "https://github.com/TRIQS/c2py.git", branch: "unstable"

  depends_on "cmake" => [:build, :test]
  depends_on "fmt"=> :build
  depends_on "ninja" => [:build, :test]

  depends_on "llvm"
  depends_on "python"

  def install
    args = %W[
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DBuild_Tests=ON
      -DBuild_Deps=IfNotFound
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
