import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firestore_path.dart';

class CloudStorage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile({String? filePath, String? uid}) async {
    File file = File(filePath!);
    try {
      await storage.ref('$uid/profilepicture.jpg').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      Text(e.toString());
    }
  }

  uploadNewImageToFirebase(String uid) async {
    final ref = storage.ref().child('$uid/profilepicture.jpg');
    String url = await ref.getDownloadURL();
    final docRef = FirestorePath.userProfileDocumentPath(uid);
    await docRef.set({'userProfilePicture': url}, SetOptions(merge: true));
  }
}

final cloudStorageFunctions = Provider((ref) => CloudStorage());
