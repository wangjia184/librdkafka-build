pushd librdkafka
./configure
make clean
make
popd

mkdir -p package-linux/runtimes/rhel-x64/native
cp librdkafka/src/librdkafka.so.1 package-linux/runtimes/rhel-x64/native/librdkafka.so
