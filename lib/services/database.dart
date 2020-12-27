import 'package:flutter/foundation.dart';
import 'package:time_tracker/app/models/job.dart';
import 'package:time_tracker/services/api_path.dart';
import 'package:time_tracker/services/firestore_service.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job>> jobsStream();
}

class FireStoreDatabase implements Database {
  FireStoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;
  final _service = FirestoreService.instance;
  @override
  Future<void> createJob(Job job) async => await _service.setData(
        documentPath: ApiPath.job(uid, 'job_abc'),
        data: job.toMap(),
      );
  Stream<List<Job>> jobsStream() => _service.collectionStream(
        documentPath: ApiPath.jobs(uid),
        builder: (data) => Job.formMap(data),
      );
}
