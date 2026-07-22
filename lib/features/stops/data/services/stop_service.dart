import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/stop_model.dart';

class StopService {
  StopService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _stops =>
      _firestore.collection('stops');

  Future<List<StopModel>> fetchStops(List<String> stopIds) async {
    if (stopIds.isEmpty) return [];

    final chunks = <List<String>>[];
    for (var i = 0; i < stopIds.length; i += 30) {
      final end = (i + 30 > stopIds.length) ? stopIds.length : i + 30;
      chunks.add(stopIds.sublist(i, end));
    }

    final results = <StopModel>[];
    for (final chunk in chunks) {
      final snapshot =
      await _stops.where(FieldPath.documentId, whereIn: chunk).get();

      results.addAll(
        snapshot.docs.map((doc) => StopModel.fromMap(doc.id, doc.data())),
      );
    }

    results.sort(
          (a, b) => stopIds.indexOf(a.id).compareTo(stopIds.indexOf(b.id)),
    );

    return results;
  }

  Future<StopModel?> fetchStop(String stopId) async {
    final doc = await _stops.doc(stopId).get();
    if (!doc.exists) return null;
    return StopModel.fromMap(doc.id, doc.data()!);
  }
}