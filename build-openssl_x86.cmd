REM "NASM (http://www.nasm.us) is required to compile OpenSSL"
REM "ActivePerl (http://www.activestate.com/activeperl) is required to compile OpenSSL"
REM "Perl module Text::Template is required to compile OpenSSL"

CALL "F:\Program Files (x86)\Microsoft Visual Studio 12.0\VC\vcvarsall.bat" x86

SET var=%cd%
ECHO %var%

cd openssl



git reset --hard HEAD
git checkout OpenSSL_1_0_2-stable

git reset --hard origin/OpenSSL_1_0_2-stable

mkdir %var%\openssl_dist
mkdir %var%\openssl_dist\x86

git clean -f

perl Configure VC-WIN32  --prefix=%var%\openssl_dist\x86
CALL ms\do_nasm.bat
nmake -f ms/nt.mak clean
nmake -f ms/nt.mak
REM nmake -f ms/nt.mak test 
nmake -f ms/nt.mak install


PAUSE