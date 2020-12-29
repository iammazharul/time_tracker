import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/jobs/edit_job_page.dart';
import 'package:time_tracker/app/home/jobs/job_list_tile.dart';
import 'package:time_tracker/app/home/models/job.dart';
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

  Widget _buildContent(BuildContext context) {
    final database = Provider.of<Database>(context);

    return StreamBuilder<List<Job>>(
      stream: database.jobsStream(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final jobs = snapshot.data;
          final children = jobs
              .map(
                (job) => JobListTile(
                  job: job,
                  ontap: () => EditJobPage.show(context, job: job),
                ),
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
        onPressed: () => EditJobPage.show(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
