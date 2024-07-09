import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:fight_gym/data/local_storage/fodder.dart' if (dart.library.html) 'dart:html';

AndroidOptions androidOptions = const AndroidOptions( encryptedSharedPreferences: true, );
final FlutterSecureStorage storage = FlutterSecureStorage( aOptions: androidOptions, );

class SecureStorage {
    writeSecureData(String key, String value) async {
        if (kIsWeb) {
            //ignore: undefined_identifier
            window.localStorage[key] = value;
        } else {
            // NOT running on the web! You can check for additional platforms here.
            await storage.write(key: key, value: value);
        }
    }

    readSecureData(String key) async {
        if (kIsWeb) {
            //ignore: undefined_identifier
            return window.localStorage[key] ?? "";
        } else {
            String value = await storage.read(key: key) ?? "";
            return value;
        }
    }

    Future<void> deleteSecureData(String key) async {
        if (kIsWeb) {
            //ignore: undefined_identifier
            window.localStorage.remove(key);
        } else {
            await storage.delete(key: key);
        }
    }
}
