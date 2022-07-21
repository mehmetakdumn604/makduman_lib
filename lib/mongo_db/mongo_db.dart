// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:makduman_lib/core/constants.dart';
import 'package:makduman_lib/mongo_db/models/user_model.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoDbService {
  static late Db _db;
  static late DbCollection _userCollection;

  static Future<void> init() async {
    try {
      _db = await Db.create(Constants.MONN_CONN_URL);
      await _db.open();
      inspect(_db);
      await _db.getCollectionNames().then((value) => print(value.length));
      _userCollection = _db.collection(Constants.USER_COLL);
    } catch (e) {
      print("HATA : $e");
    }
  }

  static Future<void> addUser() async {
    try {
      await _userCollection.insertOne({
        "name": "Mehmet 3",
        "surname": "Akduman 3",
        "age": 22,
      });
    } catch (e) {
      print("HATA : $e");
    }
  }

  static Future<void> deleteUser(UserModel userModel) async {
    try {
      await _userCollection.deleteOne(userModel.toMap());
    } catch (e) {
      print("HATA : $e");
    }
  }

  static Future<void> updateUser(UserModel userModel) async {
    try {
      Map newInfo = userModel.toMap();
      newInfo["name"] = "hade bakalım ";
      await _userCollection.update(userModel.toMap(), newInfo);
    } catch (e) {
      print("HATA : $e");
    }
  }

  static Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      return await _userCollection.find().toList();
    } catch (e) {
      print("HATA : e");
      throw Exception("hta");
    }
  }
}
