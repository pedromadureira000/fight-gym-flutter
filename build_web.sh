#!/bin/bash

flutter build web --dart-define-from-file=".env"
# flutter build web --web-renderer html --dart-define-from-file=".env"

# rm -rf ~/Projects/fully-featured/flutter_web_build/*
# zip -r web_build.zip ~/Projects/fully-featured/build/web/*
# mv web_build.zip ~/Projects/fully-featured/flutter_web_build/web_build.zip
