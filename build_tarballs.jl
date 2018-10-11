# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "SassBuilder"
version = v"0.1.0"

# Collection of sources required to build SassBuilder
sources = [
    "https://github.com/sass/libsass.git" =>
    "1e52b74306b7d73a617396c912ca436dc55fd4d8",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/libsass
autoreconf --force --install
./configure --prefix=$prefix --host=$target
make -j${nproc}
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libsass", :libsass_so)
]

# Dependencies that must be installed before this package can be built
dependencies = [
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
