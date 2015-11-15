1 安装 gcc-4.9

sudo apt-get install software-properties-common python-software-properties
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt-get update
sudo apt-get install g++-4.9
sudo apt-get install gcc-4.9-multilib g++-4.9-multilib

2 安装若干依赖库（可选，没搞清楚有没用）

sudo apt-get install libaio-dev ninja-build ragel libhwloc-dev libnuma-dev libpciaccess-dev libcrypto++-dev libboost-all-dev libxen-dev libxml2-dev xfslibs-dev

3. 安装 cmake  , 必须 3.3.3 以上

4. 安装依赖开发库

sudo apt-get install  libcurl4-openssl-dev libxml2-dev libxslt-dev python-dev lib32z1-dev libzmq3-dev libzookeeper-mt-dev libevent-dev
需要注意，是 zmq3
需要手工安装 libjson
wget -c http://tcpdiag.dl.sourceforge.net/project/libjson/libjson_7.6.1.zip
需要调整 配置文件 JSONOption  JSON_LIBRARY 关闭 c 语言接口
需要参考 Data-Core 之前的补丁，这个库代码质量不高, 必须是 7.5.1

在 mac 上需要 zmq4

需要 boost-1.59 可以编译过
brew install boost --with-python

mac 上，还需要  brew install google-sparsehash
#2.0.3 即可
brew install gperftools  libxml2 curl

5. 需要调整系统的依赖库路径

6. Boost 有文本问题，系统自带的无法编译 fiber ，需要检查deps 包种的版本
