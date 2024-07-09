#!/bin/bash
./build_web.sh
rm -rf ~/Projects/fight-gym-flutter/build/web/canvaskit
firebase deploy
