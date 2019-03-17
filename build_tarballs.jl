# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "libsass"
version = v"3.5.5"

# Collection of sources required to build SassBuilder
sources = [
    "https://github.com/sass/libsass.git" =>
    "39e30874b9a5dd6a802c20e8b0470ba44eeba929",
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/libsass
autoreconf --force --install
./configure --prefix=$prefix --host=$target
make -j${nproc}
make install
"""

platforms = [
    # glibc Linuces
    Linux(:i686),
    Linux(:x86_64),
    Linux(:aarch64),
    Linux(:armv7l),
    Linux(:powerpc64le),

    # musl Linuces
    Linux(:i686, :musl),
    Linux(:x86_64, :musl),
    Linux(:aarch64, :musl),
    Linux(:armv7l, :musl),

    # BSDs
    MacOS(:x86_64),
    FreeBSD(:x86_64),

    # Windows
    Windows(:i686),
    Windows(:x86_64, compiler_abi = CompilerABI(:gcc7))
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libsass", :libsass_so)
]

# Dependencies that must be installed before this package can be built
dependencies = [
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
