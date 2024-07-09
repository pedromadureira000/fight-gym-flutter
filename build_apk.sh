#!/bin/bash

flutter build apk --release --split-debug-info=build/whatever --dart-define-from-file=".env"
