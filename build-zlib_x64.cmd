CALL "F:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" amd64

SET var=%cd%
ECHO %var%

mkdir lib
mkdir lib\x64

cd zlib



git reset --hard HEAD
git checkout master

git reset --hard origin/master



git clean -f

nmake -f win32/Makefile.msc AS=ml64 LOC="-DASMV -DASMINF -I." OBJA="inffasx64.obj gvmat64.obj inffas8664.obj"
copy /Y zlib.lib %var%\lib\x64\zlib.lib

PAUSE