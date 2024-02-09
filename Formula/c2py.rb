class C2py < Formula
  desc "Clair/c2py"
  homepage "https://github.com/TRIQS/c2py"
  url "https://github.com/flatironinstitute/c2py/archive/refs/tags/v0.1.tar.gz"
  sha256 "5ca83f91b898238d533a34007a1585df2d1f6a3a18a10a1a8bc81166812df4da"
  license "Apache-2.0"
  head "https://github.com/TRIQS/c2py.git", branch: "unstable"

  depends_on "cmake" => [:build, :test]
  depends_on "fmt"=> :build
  depends_on "ninja" => [:build, :test]

  depends_on "llvm"
  #depends_on "python@3.12" # automatic from llvm

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
