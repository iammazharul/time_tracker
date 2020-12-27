import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/models/job.dart';
import 'package:time_tracker/common_widget/firebase_platform_exception_alert_dialog.dart';
import 'package:time_tracker/common_widget/platform_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/services/database.dart';

class JobsPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);

      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confrimSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAlertDialog(
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      defaultActiontext: 'Logout',
      cancelActiontext: 'Cancel',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  Future<void> _createJob(BuildContext context) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.createJob(Job(name: 'Youtubeing', ratePerHour: 15));
    } on FirebaseException catch (exception) {
      FirebasePlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: exception,
      ).show(context);
    }
  }

  Widget _buildContent(BuildContext context) {
    final database = Provider.of<Database>(context);

    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final jobs = snapshot.data;
          final children = jobs
              .map(
                (job) => Text(job.name),
              )
              .toList();
          return ListView(
            children: children,
          );
        }
        return Center(child: CircularProgressIndicator());
      },
      );
  }

  @override
  Widget build(BuildContext context) {
    // final database = Provider.of<Database>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Jobs'),
        actions: [
          FlatButton(
            onPressed: () => _confrimSignOut(context),
            child: Text(
              'Logout',
              style: TextStyle(fontSize: 15.0, color: Colors.white),
            ),
          ),
        ],
      ),
      body: _buildContent(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createJob(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
