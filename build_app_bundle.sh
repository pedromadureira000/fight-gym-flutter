#!/bin/bash
flutter build appbundle --release --split-debug-info=build/whatever --dart-define-from-file=".env"
