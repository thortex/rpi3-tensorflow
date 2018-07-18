# TensorFlow for Raspberry Pi 3

Prebuilt debian package of TensorFlow for Raspberry Pi 3.

## How to Install

```
cd release
./install_requires_related2tensorflow.sh
./install_tensorflow.sh
```

## Version Information

| Name          | Version      |
|:--------------|:-------------|
| Bazel         | 0.10.0       |
| TensorFlow    | 1.9.0        |
| gcc           | 4.8.5        |

## Supported Hardwares

| Board                 | Support | CPU Core   |
|:----------------------|:--------|:-----------|
| 3 Model B+            | May Yes | armv8      |
| 3 Model B             | Yes     | armv8      |
| 2 Model B v1.2        | May Yes | armv8      |
| 2 Model B             | May Yes | armv7      |
| 1 Model B+            | No      | armv6      |
| 1 Model B             | No      | armv6      |
| Model A               | No      | armv6      |
| Model A+              | No      | armv6      |
| Zero                  | No      | armv6      |
| Zero W                | No      | armv6      |
| Computer Module 1     | No      | armv6      |
| Computer Module 3     | May Yes | armv8      |
| Computer Module 3 Lite| May Yes | armv8      |

## How to Build

Change the directory to build.
```
cd setup
```

You should build Bazel and TensorFlow with gcc 4.8 or later.
```
./039_gcc-4.8.sh
```
or
```
./044_gcc-6.sh
```

Build bazel. If you have already bazel 0.10.0 in your PATH (e.g. /usr/local/bin), this instruction is not required to build TensorFlow.
```
./040_build_bazel.sh
```
or, use prebuilt bazel binary:
```
wget -c https://github.com/thortex/rpi3-echo/releases/download/v0.0.1/bazel-0.10.0.bin
sudo mv bazel-0.10.0.bin /usr/local/bin
```

Build TensorFlow for Python3.
```
./045_build_tf_py3.sh
```

Build TensorFlow for Python2, if needed.
```
./046_build_tf_py2.sh
```

Update the install script which install packages related to TensorFlow.
```
cd ..
./setup/047_update_deps.sh
```


