CALL "F:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" x86

SET var=%cd%
ECHO %var%

mkdir lib
mkdir lib\x86

cd zlib



git reset --hard HEAD
git checkout master

git reset --hard origin/master



git clean -f

git apply ../0000-Statically-link-Zlib.patch --ignore-whitespace

nmake -f  win32/Makefile.msc clean
nmake -f  win32/Makefile.msc LOC="-DASMV -DASMINF" OBJA="inffas32.obj match686.obj"
nmake -f  win32/Makefile.msc test
copy /Y zlib.lib %var%\lib\x86\zlib.lib

PAUSE