set -e

if [ ! -e nuget.exe ]; then
    wget https://dist.nuget.org/win-x86-commandline/latest/nuget.exe
fi

pushd librdkafka
./configure
make clean
make
popd

mkdir -p package-linux/runtimes/linux-x64/native
cp librdkafka/src/librdkafka.so.1 package-linux/runtimes/linux-x64/native/librdkafka.so

if [ "$VERSION" = "" ]
then
    VERSION=0.9.1-ci-$TRAVIS_BUILD_NUMBER
fi

echo "Version: $VERSION"

mono nuget.exe pack librdkafka.nuspec -Version $VERSION -NoPackageAnalysis -Properties TargetOS=Linux -BasePath package-linux

if [ ! "$NUGET_API_KEY" = "" ]
then
    mono nuget.exe push RdKafka.Internal.librdkafka-Linux.$VERSION.nupkg -ApiKey $NUGET_API_KEY -Source https://api.nuget.org/v3/index.json
fi
