import 'package:hive_flutter/hive_flutter.dart';
import 'package:notebook/hive/hive_box_const.dart';

class HiveFunctions {
  static const String userBoxName =
      userHiveBox; // Make sure userHiveBox is defined and imported

  // Opens the box asynchronously
  static Future<Box> openBox(String boxName) async =>
      await Hive.openBox(userBoxName);

  // Synchronously get the opened box
  static Box get box => Hive.box(userBoxName);

  // Add multiple users
  static Future<void> addAllUser(List data) async {
    await box.addAll(data);
  }

  // Get all users as a reversed list of maps with key
  static List<Map<String, dynamic>> getAllUsers() {
    return box.keys
        .map((key) {
          final value = box.get(key);
          return {
            "key": key,
            "Title": value["Title"],
            "content": value['content'],
          };
        })
        .toList()
        .reversed
        .toList();
  }

  // Get user data by key
  static Map<String, dynamic>? getUser(int key) {
    final data = box.get(key);
    if (data == null) return null;
    return Map<String, dynamic>.from(data);
  }

  // Update user data by key
  static Future<void> updateUser(int key, Map data) async {
    await box.put(key, data);
  }

  // Delete user data by key
  static Future<void> deleteUser(int key) async {
    await box.delete(key);
  }

  // Delete all users in the box
  static Future<void> deleteAllUsers() async {
    await box.deleteAll(box.keys);
  }

  // Create a new user
  static Future<void> createUser(Map<String, dynamic> data) async {
    await box.add(data);
  }
}
