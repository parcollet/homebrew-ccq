class Clair < Formula
  desc "Clair plugins"
  homepage "https://github.com/TRIQS/clair"
  url "https://github.com/flatironinstitute/clair/archive/refs/tags/v0.1.1.tar.gz"
  sha256 "6c5d51ae918d44ca072227544b8dd173cad1dee1a0bcbdaf20650e9e68ae86b5"
  license "Apache-2.0"
  head "https://github.com/TRIQS/clair.git", branch: "unstable"

  depends_on "cmake" => [:build, :test]
  depends_on "fmt"
  depends_on "ninja" => [:build, :test]

  depends_on "parcollet/ccq/c2py"
  depends_on "llvm"
  depends_on "numpy"
  #depends_on "python@3.12"

  def install
    args = %W[
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DBuild_Tests=OFF
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
    ]

    ENV["CC"] = Formula["llvm"].opt_bin/"clang"
    ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"

    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    ohai "NOTE: The DYLD_LIBRARY_PATH must be set e.g. \n
         export DYLD_LIBRARY_PATH=/opt/homebrew/lib/:$DYLD_LIBRARY_PATH

         for clang to find its plugins as in the documentation examples.
         " 
    
  end

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
    flags = `c2py_flags`
    system Formula["llvm"].opt_bin/"clang++", "#{testpath}/my_module.cpp", "-std=c++20",
           "-L", Formula["c2py"].lib/"", "-fplugin=#{prefix}/lib/clair_c2py.dylib",
           *flags.split, "-shared", "-o",  "#{testpath}/my_module.so"
    # Write a python test
    (testpath/"test.py").write("
import my_module
c = my_module.MyClass(2,3)
assert c.f(2) == 4
")
    # run it
    #system Formula["python"].opt_bin/"python3", "#{testpath}/test.py"
    # seems more robust. In my install, it insists on using an old, removed python with the above line ?
    system "python", "#{testpath}/test.py"

    # Write a test with a cmake ?
  end
end

# rm all ccq formula
# brew uninstall `brew list --full-name -1|grep ccq`
