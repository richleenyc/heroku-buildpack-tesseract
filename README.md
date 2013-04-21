heroku-buildpack-tesseract
===========================
Added the libraries to use Tesseract on Heroku

This buildpack is built to be used through [heroku-buildpack-multi](https://github.com/ddollar/heroku-buildpack-multi).
In your app you need to:
```
heroku config:set
BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi
```

Then, create a `.buildpacks` file inside your app:
```
https://github.com/heroku/_YOUR_MAIN_BUILDPACK
https://github.com/marcolinux/heroku-buildpack-tesseract
```
See the documentation of heroku-build-multi for a detailed explanation
how to use it.

## Configuration
A variable need to be added containing the tar.gz file with the libraries compile with Vulcan
```
heroku labs:enable user-env-compile
heroku config:set TESSERACT_OCR_REMOTE_BUNDLE=https://s3.amazonaws.com/_your_builded_libs
```
an optional variable can be set for download additional languages than English
```
heroku config:set TESSERACT_OCR_LANGUAGES=jpn,ita
```

## License
MIT License. Copyright 2013 Marco Azimonti.
