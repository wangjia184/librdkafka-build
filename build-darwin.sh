set -e

if [ ! -e nuget.exe ]; then
    wget https://dist.nuget.org/win-x86-commandline/latest/nuget.exe
fi

pushd librdkafka
GCC=gcc-4.8 CXXFLAGS="-arch i386 -arch x86_64" LDFLAGS="-arch i386 -arch x86_64" CFLAGS="-arch i386 -arch x86_64 -I/usr/local/opt/openssl/include" ./configure
make clean
make
popd

OSX_RUNTIMES="osx"
for RUNTIME in $OSX_RUNTIMES
do
    mkdir -p package-darwin/runtimes/$RUNTIME/native
    cp librdkafka/src/librdkafka.1.dylib package-darwin/runtimes/$RUNTIME/native/librdkafka.dylib
done

if [ "$VERSION" = "" ]
then
    VERSION=0.9.1-ci-$TRAVIS_BUILD_NUMBER
fi

echo "Version: $VERSION"

mono nuget.exe pack librdkafka.nuspec -Version $VERSION -NoPackageAnalysis -Properties TargetOS=Darwin -BasePath package-darwin

if [ ! "$NUGET_API_KEY" = "" ]
then
    mono nuget.exe push RdKafka.Internal.librdkafka-Darwin.$VERSION.nupkg -ApiKey $NUGET_API_KEY
fi
