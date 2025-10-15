import 'dart:typed_data';
import 'dart:io' show File;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<String?> pickAndUploadImage(BuildContext context) async {
  final picker = ImagePicker();

  // Pick image from gallery
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  if (pickedFile == null) return null;

  Uint8List fileBytes;

  if (kIsWeb) {
    // For web, read as bytes
    fileBytes = await pickedFile.readAsBytes();
  } else {
    // For mobile, convert File to bytes
    final file = File(pickedFile.path);
    fileBytes = await file.readAsBytes();
  }

  try {
    final supabase = Supabase.instance.client;
    const bucketName = 'khaboki_photos';
    final filePath = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Upload bytes
    await supabase.storage
        .from(bucketName)
        .uploadBinary(
          filePath,
          fileBytes,
          fileOptions: const FileOptions(upsert: true),
        );

    // Get public URL
    final publicUrl = supabase.storage.from(bucketName).getPublicUrl(filePath);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Upload successful')));

    return publicUrl;
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Upload failed: $e')));
    debugPrint('Upload error: $e');
    return null;
  }
}
