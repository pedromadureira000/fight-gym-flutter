# fully-featured
fully-featured app (Journaling + TODO + notes + glossary)


# Run dev
```
cp env-sample .env
flutter pub run build_runner 
flutter pub get && flutter pub run build_runner build --delete-conflicting-outputs #If previous don't work
make dev
dart pub add package_name
```


# to run .sh files (necessary on make commands)
```
chmod +x filename.sh
```


# Send apk file to server
`
scp -i ~/.ssh/zap_ass.pem ~/Projects/fully-featured/build/app/outputs/flutter-apk/app-release.apk ubuntu@34.227.52.138:/home/ubuntu/fully-featured-backend/downloads/
`
