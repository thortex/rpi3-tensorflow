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
| TensorFlow    | 1.8.0        |
| gcc           | 4.8.3        |

## Supported Languages

- Italian, Tamil, Swahili, Persian, Malay, Hindi, Japanese, German, Portoguese, Russian, Simplified Chinese, Arabic, Spanish, and English.
- Tamil, Japanese Japanese_vert, and Arabic for script.

## How to Install

```
git clone https://github.com/thortex/rpi3-tesseract.git
cd rpi3-tesseract
cd release
./install_requires_related2leptonica.sh
./install_requires_related2tesseract.sh
./install_tesseract.sh
```

## Supported Hardwares

| Board                 | Support |
|:----------------------|:--------|
| 3 Model B+            | May Yes |
| 3 Model B             | Yes     |
| 2 Model B v1.2        | May Yes |
| 2 Model B             | No      |
| 1 Model B+            | No      |
| 1 Model B             | No      |
| Model A               | No      |
| Model A+              | No      |
| Zero                  | No      |
| Zero W                | No      |
| Computer Module 1     | No      |
| Computer Module 3     | May Yes |
| Computer Module 3 Lite| May Yes |

## How to Build

Change the directory to build.
```
cd setup
```

You should build Bazel and TensorFlow with gcc 4.8.
So, change your default gcc to 4.8, instead of 6 or later.
```
./039_gcc-4.8.sh
```

Build bazel. If you have already bazel 0.10.0, this instruction is not required to build Tensorflow.
```
./040_build_bazel.sh
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
./047_update_deps.sh
```

### CXXFLAGS

Options of CXXFLAGS for gcc 4.8 is listed below:

| Option | Value                |
|:-------|:---------------------|
|-mtune  | cortex-a53           |
|-march  | armv8-a+crc          |
|-mcpu   | cortex-a53           |
|-mfpu   | crypto-neon-fp-armv8 |

