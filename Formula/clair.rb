class Clair < Formula
  desc "Clair plugins"
  homepage "https://github.com/TRIQS/clair"
  # url "https://github.com/TRIQS/nda/archive/refs/tags/1.2.0.tar.gz"
  # sha256 "e054ff73512b9c43ca8c0b5036629ecf6179befd5b6b9579b963d683be377c89"
  license "Apache-2.0"
  head "https://github.com/TRIQS/clair.git", branch: "unstable"

  depends_on "cmake" => [:build, :test]
  depends_on "fmt"=> :build
  depends_on "ninja" => [:build, :test]

  depends_on "parcollet/ccq/c2py"
  depends_on "llvm"
  depends_on "numpy"
  depends_on "python"

  def install
    args = %W[
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DBuild_Tests=OFF
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
    # Write a c++ code
    (testpath/"my_module.cpp").write("
#include <c2py/c2py.hpp>
class my_class{
  int a, b;
  public:
    my_class(int a_, int b_) : a(a_), b(b_) {}
    int f(int u) const { return u + a;}
}; ")
    # Compile it
    flags = `clair_info -flags`
    system Formula["llvm"].opt_bin/"clang++", "#{testpath}/my_module.cpp", "-std=c++20",
           *flags.split, "-shared", "-o", "#{testpath}/my_module.so"
    # Write a python test
    (testpath/"test.py").write("
import my_module
c = my_module.MyClass(2,3)
assert c.f(2) == 4
")
    # run it
    system Formula["python"].opt_bin/"python3", "test.py"

    # Write a test with a cmake ?
  end
end

# rm all ccq formula
# brew uninstall `brew list --full-name -1|grep ccq`
