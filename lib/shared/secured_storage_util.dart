import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecuredStorage {
  FlutterSecureStorage storage = const FlutterSecureStorage();

  SecuredStorage() {
    init();
  }
  init() {
    //setup
    AndroidOptions getAndroidOptions() =>
        const AndroidOptions(encryptedSharedPreferences: true);
    storage = FlutterSecureStorage(aOptions: getAndroidOptions());
  }

  readData({String key = ""}) async {
    if (key.isEmpty) {
      Map<String, String> allValues = await storage.readAll();
      return allValues;
    }
    final value = await storage.read(key: key);
    return value;
  }

  writeData(String key, String value) async {
    try {
      await storage.write(key: key, value: value);
      return true;
    } catch (e) {
      return false;
    }
  }

  deleteData(String key) async {
    final value = await storage.delete(key: key);
    return value;
  }
}
