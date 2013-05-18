heroku-buildpack-tesseract
===========================
Added the libraries to use Tesseract on Heroku

This buildpack is built to be used through [heroku-buildpack-multi](https://github.com/ddollar/heroku-buildpack-multi).
In your app you need to:
```
heroku config:set BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi
```

Then, create a `.buildpacks` file inside your app:
```
https://github.com/heroku/_YOUR_MAIN_BUILDPACK
https://github.com/marcolinux/heroku-buildpack-tesseract
```
See the documentation of heroku-build-multi for a detailed explanation
how to use it.
## Build on Vulcan
A script to build on Vulcan is available under the `/utils` folder.
it is necessary to create beforehands a [vulcan](https://github.com/heroku/vulcan) build server.
```
gem install vulcan
vulcan create _your_vulcan_server_
```

## Configuration
A variable need to be added containing the full path of the tar.gz file with the libraries compile with Vulcan
```
heroku labs:enable user-env-compile
heroku config:set TESSERACT_OCR_REMOTE=https://s3.amazonaws.com/_your_builded_libs.tar.gz
```

If you want to access the libraries compiled with Vulcan and hosted on Heroku Vulcan server, it is possible
with a similar configuration (the path is the result of the vulcan build process).
```
heroku labs:enable user-env-compile
heroku config:set TESSERACT_OCR_REMOTE=http://_your_vulcan_server_.herokuapp.com/output/_compiled_hash
```

An optional variable can be set for download additional languages than English
```
heroku config:set TESSERACT_OCR_LANGUAGES=jpn,ita
```

## License
MIT License. Copyright 2013 Marco Azimonti.
