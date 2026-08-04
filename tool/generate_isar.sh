#!/bin/bash
set -e
flutter pub add dev:isar_generator:^3.1.0+1 --dev
dart run build_runner build --delete-conflicting-outputs --build-filter="lib/core/ai/memory/**"
flutter pub remove isar_generator
echo "Done - commit *.g.dart now"
