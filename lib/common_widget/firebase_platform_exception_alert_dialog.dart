import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'platform_alert_dialog.dart';

class FirebasePlatformExceptionAlertDialog extends PlatformAlertDialog {
  FirebasePlatformExceptionAlertDialog({
    @required String title,
    @required FirebaseException exception,
  }) : super(
            title: title,
            content: _message(exception),
            defaultActiontext: 'OK');

  static String _message(FirebaseException exception) {
    return _errors[exception.code] ?? exception.message;
  }

  static Map<String, String> _errors = {
    'email-already-in-use':
        'There already exists an account with the given email address.',
    'invalid-email': 'Thrown if the email address is not valid.',
    'operation-not-allowed': 'Email/password accounts are not enabled.',
    'weak-password': 'Thrown if the password is not strong enough.'
  };
}
