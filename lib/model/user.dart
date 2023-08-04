import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  String? id;
  String name;
  String address;
  String? image;
  User({required this.id, required this.name, required this.address, required this.image});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  factory User.fromMap(String id, Map<dynamic, dynamic> map) {
    return User(
      id: id ?? '',
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      image: map['image'] ?? ''
    );
  }
}
