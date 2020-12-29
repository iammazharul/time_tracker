import 'package:flutter/material.dart';
import 'package:time_tracker/app/home/models/job.dart';

class JobListTile extends StatelessWidget {
  const JobListTile({Key key, this.job, this.ontap}) : super(key: key);
  final Job job;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(job.name),
      onTap: ontap,
      trailing: Icon(Icons.chevron_right),
    );
  }
}
