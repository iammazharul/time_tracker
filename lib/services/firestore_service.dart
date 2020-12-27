import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();
  
  Future<void> setData({String documentPath, Map<String, dynamic> data}) async {
    final documantReference = FirebaseFirestore.instance.doc(documentPath);
    await documantReference.set(data);
  }

  Stream<List<T>> collectionStream<T>({
    @required String documentPath,
    @required T builder(Map<String, dynamic> data),
  }) {
    final documantReference =
        FirebaseFirestore.instance.collection(documentPath);
    final snapshots = documantReference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map(
          (snapshot) => builder(snapshot.data()),
        )
        .toList());
  }
}
