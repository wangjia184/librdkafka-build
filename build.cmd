::@echo off

cd %~dp0

SETLOCAL
SET NUGET_VERSION=latest

mkdir lib
mkdir lib\x64
mkdir lib\x86

echo git clone OpenSSL
git clone -q --branch=OpenSSL_1_0_2-stable https://github.com/openssl/openssl.git
CALL "build-openssl_x64.cmd"
CALL "build-openssl_x86.cmd"

echo git clone zlib
git clone -q --branch=master https://github.com/madler/zlib.git
CALL "build-zlib_x64.cmd"
CALL "build-zlib_x86.cmd"



echo git clone librdkafka
git clone -q --branch=0.9.2.x https://github.com/edenhill/librdkafka.git


IF EXIST nuget.exe goto build
echo Downloading nuget.exe
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest 'https://dist.nuget.org/win-x86-commandline/%NUGET_VERSION%/nuget.exe' -OutFile nuget.exe"

:build

echo Applying patches
cd librdkafka
echo git reset --hard HEAD
git reset --hard HEAD
if %errorlevel% neq 0 exit /b %errorlevel%
echo git apply ../0001-Statically-link-OpenSSL-and-MSVCR-on-Windows.patch --ignore-whitespace
git apply ../0001-Statically-link-OpenSSL-and-MSVCR-on-Windows.patch --ignore-whitespace
echo git apply ../0002-Fix-linking-of-rdkafka_consumer_example_cpp.patch --ignore-whitespace
git apply ../0002-Fix-linking-of-rdkafka_consumer_example_cpp.patch --ignore-whitespace
echo git apply ../0003-Fix-linking-of-win-x64-tests.patch --ignore-whitespace
git apply ../0003-Fix-linking-of-win-x64-tests.patch --ignore-whitespace
echo git apply ../0004-Add-missing-include-path-to-rdkafka_consumer_example.patch --ignore-whitespace
git apply ../0004-Add-missing-include-path-to-rdkafka_consumer_example.patch --ignore-whitespace
echo git apply ../0005-Fix-x64-lib-paths-for-rdkafka_consumer_example_cpp.patch --ignore-whitespace
git apply ../0005-Fix-x64-lib-paths-for-rdkafka_consumer_example_cpp.patch --ignore-whitespace
if %errorlevel% neq 0 exit /b %errorlevel%
cd ..

echo Nuget restore
@nuget restore librdkafka/win32/librdkafka.sln || exit /b

@msbuild librdkafka/win32/librdkafka.sln /property:Configuration=Release /property:Platform=Win32 || exit /b
@msbuild librdkafka/win32/librdkafka.sln /property:Configuration=Release /property:Platform=x64 || exit /b

if not exist package-win\runtimes\win7-x86\native md package-win\runtimes\win7-x86\native || exit /b
if not exist package-win\runtimes\win7-x64\native md package-win\runtimes\win7-x64\native || exit /b

copy librdkafka\win32\Release\librdkafka.dll package-win\runtimes\win7-x86\native || exit /b

copy librdkafka\win32\x64\Release\librdkafka.dll package-win\runtimes\win7-x64\native || exit /b


if defined APPVEYOR_BUILD_VERSION (
nuget.exe pack librdkafka.nuspec -Version %APPVEYOR_BUILD_VERSION% -NoPackageAnalysis -Properties TargetOS=Windows -BasePath package-win || exit /b
) else (
nuget.exe pack librdkafka.nuspec -NoPackageAnalysis -Properties TargetOS=Windows -BasePath package-win || exit /b
)

if defined NUGET_API_KEY if defined APPVEYOR_BUILD_VERSION (
echo Uploading nuget package
@nuget.exe push RdKafka.Internal.librdkafka-Windows.%APPVEYOR_BUILD_VERSION%.nupkg -ApiKey %NUGET_API_KEY% -Source https://api.nuget.org/v3/index.json || exit /b
)
