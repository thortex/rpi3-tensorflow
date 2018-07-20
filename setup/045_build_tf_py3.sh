#!/bin/bash -x
V=1.9.0

# Retrieve the specified version of tensorflow.
wget -c https://github.com/tensorflow/tensorflow/archive/v${V}.tar.gz
tar xzf v${V}.tar.gz

# install pre-required packages.
sudo apt-get install \
     libeigen2-dev libeigen3-dev \
     libblas-dev liblapack-dev \
     libatlas-base-dev gfortran

# substitute lib for lib64.
cd tensorflow-$V && grep -Rl 'lib64' | xargs sed -i 's/lib64/lib/g'

# as-a-work-around for newer tensorflow's link error.
sed -i 's/ ConcatCPU/ \/\/ConcatCPU/;' tensorflow/core/kernels/list_kernels.h

# A link error occurrs, if the version of tensorflow
# is equal to 1.8.0.
if [ "$V" = "1.8.0" ] ; then
    echo "Applying png patch..."
    f=third_party/png.BUILD
    x=`grep PNG_ARM_NEON_OPT $f`
    if [ "x$x" = "x" ] ; then
	sed -i 's/visibility /copts = ["-DPNG_ARM_NEON_OPT=0"],\n    visibility /;' $f
    fi
fi

# as-a-work-around for Runtime error.
D=tensorflow/python/framework/
F=${D}op_def_registry.py
x=`grep PeriodicResample $F`
if [ "x$x" = "x" ] ; then
    sed -i 's/assert/if op_def.name == "PeriodicResample": continue\n      assert/;' $F
fi

# For newer boringSSL C/C++ flags on an ARM host cpu.
F=tensorflow/workspace.bzl
sed -i 's/524ba98a56300149696481b4cb9ddebd0c7b7ac9b9f6edee81da2d2d7e5d2bb3/d53bc28cd12f59dfc0881ab9781b60ab9101ff0e4bb1cf10255444c4f67c05b6/;' $F
sed -i 's/https:\/\/mirror.bazel.build\/github.com\/google\/boringssl\/archive\/a0fb951d2a26a8ee746b52f3ba81ab011a0af778.tar.gz/https:\/\/github.com\/thortex\/rpi3-tensorflow\/releases\/download\/v1.9.0\/a0fb951d2a26a8ee746b52f3ba81ab011a0af778.tar.bz2/;' $F
sed -i 's/https:\/\/github.com\/google\/boringssl\/archive\/a0fb951d2a26a8ee746b52f3ba81ab011a0af778.tar.gz/https:\/\/github.com\/thortex\/rpi3-tensorflow\/releases\/download\/v1.9.0\/a0fb951d2a26a8ee746b52f3ba81ab011a0af778.tar.bz2/;' $F

# configure
(PYTHON_BIN_PATH=/usr/bin/python3 \
 PYTHON_LIB_PATH=/usr/local/lib/python3.5/dist-packages \
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
bazel-bin/tensorflow/tools/pip_package/build_pip_package $D
R=release/

F=bazel-bin/tensorflow/tools/benchmark/benchmark_model
if [ -e "$F" ] ; then
    cp $F ../$R
fi
F=bazel-bin/tensorflow/libtensorflow.so
if [ -e "$F" ] ; then
    cp $F ../$R
fi
F=bazel-bin/tensorflow/libtensorflow_framework.so
if [ -e "$F" ] ; then
    cp $F ../$R
fi

# move file to release
cd ..
F=tensorflow-${V}-cp35-cp35m-linux_armv7l.whl
if [ -e "$D$F" ] ; then
    mv $D$F ../$R
fi

#sudo pip3 install $R/$F

# Swapoff, if needed.
# https://github.com/samjabrahams/tensorflow-on-raspberry-pi/blob/master/GUIDE.md
