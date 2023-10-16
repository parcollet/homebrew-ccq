class Nda < Formula
  desc "C++ multi-dimensionnal array library"
  homepage "https://github.com/TRIQS/nda"
  url "https://github.com/TRIQS/nda/archive/refs/tags/1.2.0.tar.gz"
  sha256 "e054ff73512b9c43ca8c0b5036629ecf6179befd5b6b9579b963d683be377c89"
  license "Apache-2.0"
  head "https://github.com/TRIQS/nda.git"

  depends_on "cmake" => :build
  depends_on "llvm"
  depends_on "open-mpi"

  def install
    args = %W[
      -DCMAKE_BUILD_TYPE=Release
      -DCMAKE_INSTALL_PREFIX=#{prefix}
    ]

    ENV["CC"] = Formula["llvm"].opt_bin/"clang"
    ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test parcollet/ccq/nda`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
