CI build scripts for librdkafka shared library used by https://github.com/ah-/rdkafka-dotnet


## Build Tools

* ActivePerl (required by OpenSSL)
* NASM

## Build the dependencies as static lirbaries (windows)

Open the scripts below, find the line like

```
CALL "F:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" ...
```

Change the path to your VC 2013 installation's vcvarsall.bat

Then run each of them.

| Script | Output file | Comments |
|---|---|---|
| build-openssl_x64.cmd | lib\x64\libeay32MT.lib & lib\x64\ssleay32MT.lib | OpenSSL for Windows x86_64 |
| build-openssl_x86.cmd | lib\x86\libeay32MT.lib & lib\x86\ssleay32MT.lib | OpenSSL for Windows x86 |
| build-zlib_x64.cmd | lib\x64\zlib.lib | Zlib for Windows x86_64 |
| build-zlib_x86.cmd | lib\x86\zlib.lib | Zlib for Windows x86 |