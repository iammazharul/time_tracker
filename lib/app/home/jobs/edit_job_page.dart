import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/models/job.dart';
import 'package:time_tracker/common_widget/firebase_platform_exception_alert_dialog.dart';
import 'package:time_tracker/common_widget/platform_alert_dialog.dart';
import 'package:time_tracker/services/database.dart';

class EditJobPage extends StatefulWidget {
  final Database database;
  final Job job;

  const EditJobPage({Key key, @required this.database, this.job})
      : super(key: key);
  static Future<void> show(BuildContext context, {Job job}) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EditJobPage(
          database: database,
          job: job,
        ),
      ),
    );
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();
  String _name;
  int _ratePerHour;
  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allName = jobs.map((job) => job.name).toList();
        if (widget.job != null) {
          allName.remove(widget.job.name);
        }
        if (allName.contains(_name)) {
          PlatformAlertDialog(
            title: "Name already use",
            content: 'Please chose a different name',
            defaultActiontext: 'OK',
          ).show(context);
        } else {
          final id = widget.job?.id ?? documentIdFormCurrentDate();
          final job = Job(id: id, name: _name, ratePerHour: _ratePerHour);
          await widget.database.setJob(job);
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (exception) {
        FirebasePlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: exception,
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job == null ? 'New Job' : 'Update Job'),
        actions: [
          FlatButton(
            onPressed: () => _submit(),
            child: Text(
              widget.job != null ? 'Update' : 'Create',
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          )
        ],
      ),
      body: _builContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _builContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildFormChildren(),
        ));
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        initialValue: _name,
        decoration: InputDecoration(labelText: 'Job name'),
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value.trim(),
      ),
      TextFormField(
        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
        decoration: InputDecoration(labelText: 'Rate per hour'),
        keyboardType:
            TextInputType.numberWithOptions(signed: false, decimal: false),
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
      )
    ];
  }
}
