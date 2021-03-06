import 'package:flutter/foundation.dart';
import 'package:time_tracker/app/home/models/job.dart';
import 'package:time_tracker/services/api_path.dart';
import 'package:time_tracker/services/firestore_service.dart';

abstract class Database {
  Future<void> setJob(Job job);
  Stream<List<Job>> jobsStream();
}

String documentIdFormCurrentDate() => DateTime.now().toIso8601String();

class FireStoreDatabase implements Database {
  FireStoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;
  final _service = FirestoreService.instance;
  @override
  Future<void> setJob(Job job) async => await _service.setData(
        documentPath: ApiPath.job(
          uid,
          job.id,
        ),
        data: job.toMap(),
      );
  Stream<List<Job>> jobsStream() => _service.collectionStream(
        documentPath: ApiPath.jobs(uid),
        builder: (data,documentId) => Job.formMap(data, documentId),
      );
}
