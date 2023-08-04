import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:listuserwithfirebase/model/user.dart';

class Presenter {
  int? count;
  List<User> userList = <User>[];
  final DatabaseReference reference =
      FirebaseDatabase.instance.ref().child('user');

  void saveData(User user) {
    reference.push().set(user.toJson());
  }

  Query getUserQuery() {
    return reference;
  }

  Future<int?> countData() async {
    await reference.onValue.listen((event) {
      final dataSnapshot = event.snapshot;
      final length = dataSnapshot.children.length;

      count = length;
    });
    return count;
  }

  Future<List<User>> parsingData() async {
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('user').once();
    userList.clear(); // Clear the list before adding new data

    final userData = snapshot.snapshot.value as Map<dynamic, dynamic>;

    userData.forEach((key, value) {
      User user = User.fromMap(key, value);
      print('id? :${user.id}');
      userList.add(user);
    });

    return userList;
  }

  Future updateData(String id, String name, String address, String image) async {
    final postData = User(id: null, name: name, address: address, image: image);
    final newPostKey = FirebaseDatabase.instance.ref().child('user/${id}').key;
    final Map<String, Map> updates = {};
    updates['/user/$newPostKey'] = postData.toJson();
    FirebaseDatabase.instance.ref().update(updates);
  }

  Future deleteData(String id) async {
    FirebaseDatabase.instance.ref().child('user/${id}').remove();
  }
}
