::@echo off
cd %~dp0

SETLOCAL
SET NUGET_VERSION=latest

IF EXIST nuget.exe goto build
echo Downloading nuget.exe
@powershell -NoProfile -ExecutionPolicy unrestricted -Command "$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest 'https://dist.nuget.org/win-x86-commandline/%NUGET_VERSION%/nuget.exe' -OutFile nuget.exe"

:build
C:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat

echo Nuget restore
@nuget restore librdkafka/win32/librdkafka.sln

@msbuild librdkafka/win32/librdkafka.sln /property:Configuration=Release /property:Platform=Win32
@msbuild librdkafka/win32/librdkafka.sln /property:Configuration=Release /property:Platform=x64

if not exist package-win\runtimes\win7-x86\native md package-win\runtimes\win7-x86\native
if not exist package-win\runtimes\win7-x64\native md package-win\runtimes\win7-x64\native

copy librdkafka\win32\Release\librdkafka.dll package-win\runtimes\win7-x86\native
copy librdkafka\win32\Release\zlib.dll package-win\runtimes\win7-x86\native

copy librdkafka\win32\x64\Release\librdkafka.dll package-win\runtimes\win7-x64\native
copy librdkafka\win32\x64\Release\zlib.dll package-win\runtimes\win7-x64\native

if defined APPVEYOR_BUILD_VERSION (
nuget.exe pack librdkafka.nuspec -Version %APPVEYOR_BUILD_VERSION% -NoPackageAnalysis -Properties TargetOS=Windows -BasePath package-win
) else (
nuget.exe pack librdkafka.nuspec -NoPackageAnalysis -Properties TargetOS=Windows -BasePath package-win
)

if defined NUGET_API_KEY and defined APPVEYOR_BUILD_VERSION (
echo Uploading nuget package
@nuget.exe push RdKafka.Internal.librdkafka-Windows.%APPVEYOR_BUILD_VERSION%.nupkg -ApiKey %NUGET_API_KEY%
)