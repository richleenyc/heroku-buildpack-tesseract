#! /bin/bash

while test $# -gt 0; do
        case "$1" in
                -h|--help)
                        echo "build with -f or --fullpackage if you wish to get all the includes files"
                        exit 0
                        ;;
                -f|--fullpackage)
                       shift
                       FULLPACKAGE=true
                       shift
                       ;;
                *)
                        break
                        ;;
        esac
done

TESSERACT_V=3.02.02
LEPTONICA_V=1.69
LOCALBUILDDIR=./vulcanBuild
BUILDDIR=/tmp/build
PACKAGEDIR=/tmp/package
BUILDFILE=./vulcan.sh

# Copy the source files locally
curl https://tesseract-ocr.googlecode.com/files/tesseract-ocr-$TESSERACT_V.tar.gz -o tesseract-ocr-$TESSERACT_V.tar.gz
curl http://www.leptonica.org/source/leptonica-$LEPTONICA_V.tar.gz -o leptonica-$LEPTONICA_V.tar.gz
mkdir vulcanBuild
tar -C vulcanBuild -zxvf tesseract-ocr-$TESSERACT_V.tar.gz
tar -C vulcanBuild -zxvf leptonica-$LEPTONICA_V.tar.gz

# Prepare the Vulcan build script
touch $BUILDFILE
echo "#! /bin/bash" > $BUILDFILE
# Build Leptonica
echo "cd leptonica-$LEPTONICA_V" >> $BUILDFILE
echo "./configure --prefix=$BUILDDIR/leptonica-$LEPTONICA_V --exec-prefix=$BUILDDIR/leptonica-$LEPTONICA_V" >> $BUILDFILE
echo "make" >> $BUILDFILE
echo "make install" >> $BUILDFILE
# Build Tesseract
echo "cd ../tesseract-ocr" >> $BUILDFILE
echo "./autogen.sh" >> $BUILDFILE
echo "export LIBLEPT_HEADERSDIR=$BUILDDIR/leptonica-$LEPTONICA_V/include" >> $BUILDFILE
echo "export LIBLEPT_LIBSDIR=$BUILDDIR/leptonica-$LEPTONICA_V/lib" >> $BUILDFILE
echo "./configure --prefix=$BUILDDIR/tesseract-ocr-$TESSERACT_V --with-extra-libraries=\$LIBLEPT_LIBSDIR" >> $BUILDFILE
echo "make install" >> $BUILDFILE
# Copy the relevant files needed by the buildPack
echo "mkdir $PACKAGEDIR" >> $BUILDFILE
echo "mkdir $PACKAGEDIR/bin" >> $BUILDFILE
echo "mkdir $PACKAGEDIR/lib" >> $BUILDFILE
echo "cp $BUILDDIR/leptonica-$LEPTONICA_V/lib/liblept.so.3 $PACKAGEDIR/lib" >> $BUILDFILE
echo "cp $BUILDDIR/tesseract-ocr-$TESSERACT_V/lib/libtesseract.so.3 $PACKAGEDIR/lib" >> $BUILDFILE
echo "cp $BUILDDIR/tesseract-ocr-$TESSERACT_V/bin/tesseract $PACKAGEDIR/bin" >> $BUILDFILE

# Copy the Vulcan Build file to the proper location with the sources
chmod 754 $BUILDFILE
mv $BUILDFILE $LOCALBUILDDIR

# Launch the build on Vulcan
if [ $FULLPACKAGE ]; then
  echo "Building Full Package"
  vulcan build -v -s $LOCALBUILDDIR -p $BUILDDIR -c "$BUILDFILE"
else
  echo "Building Buildpack Package"
  vulcan build -v -s $LOCALBUILDDIR -p $PACKAGEDIR -c "$BUILDFILE"
fi
