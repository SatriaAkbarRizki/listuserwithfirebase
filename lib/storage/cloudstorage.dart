import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';

class CloudStorage {
  Future<String?> uploadImage(File? imagePath) async {
    try {
      String filename = basename(imagePath!.path);
      final storageRef =
          FirebaseStorage.instance.ref().child("image/${filename}");

      final uploadTask = storageRef.putFile(imagePath); // Start the upload task
      final snapshot = await uploadTask
          .whenComplete(() {}); // Wait for the upload to complete

      if (snapshot.state == TaskState.success) {
        final result = await storageRef.getDownloadURL();
        return result;
      } else {
        print("Upload failed");
        return null;
      }
    } catch (e) {
      print('Error: ${e.toString()}');
      return null;
    }
  }
}
