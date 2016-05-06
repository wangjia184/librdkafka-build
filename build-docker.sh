yum -y groupinstall 'Development Tools'
yum -y install zlib-devel
yum -y install openssl-devel
yum -y install libsasl2-devel

pushd librdkafka
./configure
make clean
make
popd
