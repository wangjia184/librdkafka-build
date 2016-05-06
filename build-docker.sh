set -e

yum -y groupinstall 'Development Tools'
yum -y install zlib-devel
yum -y install openssl-devel
yum -y install cyrus-sasl-devel

pushd librdkafka
./configure
make clean
make
popd
