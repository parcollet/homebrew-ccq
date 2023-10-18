class Nda < Formula
  desc "C++ multi-dimensionnal array library"
  homepage "https://github.com/TRIQS/nda"
  url "https://github.com/TRIQS/nda/archive/refs/tags/1.2.0.tar.gz"
  sha256 "e054ff73512b9c43ca8c0b5036629ecf6179befd5b6b9579b963d683be377c89"
  license "Apache-2.0"
  head "https://github.com/TRIQS/nda.git", branch: "unstable"

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  depends_on "hdf5"
  depends_on "itertools"
  depends_on "llvm"
  depends_on "numpy"
  depends_on "open-mpi"
  depends_on "python"

  def install
    # FIXME : remove after passing to clair
    system "pip", "install", "--user", "--upgrade", "mako"
    system "pip", "install", "--user", "--upgrade", "scipy"

    args = %W[
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DPythonSupport=ON
      -DBuild_Tests=OFF
      -DBuild_Deps=IfNotFound
    ]

    ENV["CC"] = Formula["llvm"].opt_bin/"clang"
    ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"ess.cpp").write("#include <nda/nda.hpp>
                              int main() {} ")
    system Formula["llvm"].opt_bin/"clang++", "ess.cpp", "-std=c++20"
  end
end

# rm all ccq formula
# brew uninstall `brew list --full-name -1|grep ccq`
