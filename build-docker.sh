yum -y groupinstall 'Development Tools'

pushd librdkafka
./configure
make clean
make
popd
