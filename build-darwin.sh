set -e

if [ ! -e nuget.exe ]; then
    wget https://dist.nuget.org/win-x86-commandline/latest/nuget.exe
fi

pushd librdkafka
./configure
make clean
CFLAGS="-I/usr/local/opt/openssl/include" make
popd

mkdir -p package-darwin/runtimes/osx/native
cp librdkafka/src/librdkafka.1.dylib package-darwin/runtimes/osx/native/

mono nuget.exe pack librdkafka.nuspec -NoPackageAnalysis -Properties TargetOS=Darwin -BasePath package-darwin
