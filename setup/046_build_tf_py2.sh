#!/bin/bash -x
# You have to execute this script after 045_build_tf_py3.sh.
V=1.9.0
PYTHON_VER=2.7
cd tensorflow-$V
# configure
(PYTHON_BIN_PATH=/usr/bin/python2 \
 PYTHON_LIB_PATH=/usr/local/lib/python${PYTHON_VER}/dist-packages \
 TF_NEED_JEMALLOC=1 \
 TF_NEED_GCP=0 \
 TF_NEED_CUDA=0 \
 TF_NEED_S3=0 \
 TF_NEED_HDFS=0 \
 TF_NEED_KAFKA=0 \
 TF_NEED_OPENCL_SYCL=0 \
 TF_NEED_OPENCL=0 \
 TF_CUDA_CLANG=0 \
 TF_DOWNLOAD_CLANG=0 \
 TF_ENABLE_XLA=0 \
 TF_NEED_GDR=0 \
 TF_NEED_VERBS=0 \
 TF_NEED_MPI=0 \
 TF_NEED_AWS=0 \
 TF_SET_ANDROID_WORKSPACE=0 \
 CC_OPT_FLAGS=-march=native \
 ./configure)

# build.
bazel build -c opt \
      --config=monolithic \
      --copt=-DRASPBERRY_PI \
      --copt=-DS_IREAD=S_IRUSR \
      --copt=-DS_IWRITE=S_IWUSR \
      --copt=-U__GCC_HAVE_SYNC_COMPARE_AND_SWAP_1 \
      --copt=-U__GCC_HAVE_SYNC_COMPARE_AND_SWAP_2 \
      --copt=-U__GCC_HAVE_SYNC_COMPARE_AND_SWAP_8 \
      --conlyopt=-std=gnu11 \
      --copt=-march=armv7-a \
      --copt=-mfpu=neon-vfpv4 \
      --copt=-mfloat-abi=hard \
      --copt=-funsafe-math-optimizations \
      --copt=-ftree-vectorize \
      --copt=-fomit-frame-pointer \
      --verbose_failures \
      --jobs 0 \
      --local_resources 1536,3.0,1.0 \
      --cxxopt="-D_GLIBCXX_USE_CXX11_ABI=0" \
      //tensorflow/tools/pip_package:build_pip_package

# build pip pakage.
D=/tmp/tensorflow_pkg/
B=bazel-bin/tensorflow/tools/pip_package/build_pip_package
if [ -e "$B" ] ; then
    $B $D
fi
R=release/
# move file to release
cd ..
F=tensorflow-${V}-cp27-cp27mu-linux_armv7l.whl
if [ -e "$D$F" ] ; then
    mv $D$F ../$R
fi

#sudo pip2 install ../$R/$F
