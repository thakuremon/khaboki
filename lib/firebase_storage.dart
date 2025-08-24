import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

Future<String?> uploadFile(File file, String path) async {
  try {
    final ref = FirebaseStorage.instance.ref().child(path);
    final uploadTask = await ref.putFile(file);
    return await uploadTask.ref.getDownloadURL();
  } catch (e) {
    return null;
  }
}
