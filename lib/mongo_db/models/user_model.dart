import 'package:mongo_dart/mongo_dart.dart';

class UserModel {
  final ObjectId id;
  final String name, surname;
  final int age;

  UserModel(this.id, this.name, this.surname, this.age);

  factory UserModel.fromJson(ObjectId key, Map json) => UserModel(key, json["name"], json["surname"], json["age"]);

  Map<String, dynamic> toMap() =>
     {"name": name, "surname": surname, "age": age};
  
}
