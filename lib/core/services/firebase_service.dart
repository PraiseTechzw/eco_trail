import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  static FirebaseAuth get auth => FirebaseAuth.instance;
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  static FirebaseStorage get storage => FirebaseStorage.instance;

  // Initialize Firebase
  static Future<void> initialize() async {
    await Firebase.initializeApp();
  }

  // Auth methods
  static Future<UserCredential?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  static Future<UserCredential?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  static Future<void> signOut() async {
    await auth.signOut();
  }

  static User? get currentUser => auth.currentUser;

  // Firestore methods
  static Future<void> addDocument(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    await firestore.collection(collection).doc(docId).set(data);
  }

  static Future<DocumentSnapshot> getDocument(
    String collection,
    String docId,
  ) async {
    return await firestore.collection(collection).doc(docId).get();
  }

  static Future<void> updateDocument(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    await firestore.collection(collection).doc(docId).update(data);
  }

  static Future<void> deleteDocument(String collection, String docId) async {
    await firestore.collection(collection).doc(docId).delete();
  }

  static Stream<QuerySnapshot> getCollectionStream(String collection) {
    return firestore.collection(collection).snapshots();
  }

  // Storage methods
  static Future<String> uploadFile(String path, Uint8List data) async {
    final ref = storage.ref().child(path);
    await ref.putData(data);
    return await ref.getDownloadURL();
  }

  static Future<void> deleteFile(String path) async {
    await storage.ref().child(path).delete();
  }
}
