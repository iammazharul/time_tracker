import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/sign_in/email_sign_in_change_model.dart';
import 'package:time_tracker/common_widget/for_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/common_widget/platform_exception_alert_dialog.dart';
import 'package:time_tracker/services/auth.dart';

class EmailSignInFormChangeNotifier extends StatefulWidget {
  EmailSignInFormChangeNotifier({Key key, @required this.model})
      : super(key: key);
  final EmailSignInChangeModel model;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context,listen: false);
    return ChangeNotifierProvider<EmailSignInChangeModel>(
      create: (context) => EmailSignInChangeModel(auth: auth),
      child: Consumer<EmailSignInChangeModel>(
        builder: (context, model, _) =>
            EmailSignInFormChangeNotifier(model: model),
      ),
    );
  }

  @override
  _EmailSignInFormChangeNotifierState createState() =>
      _EmailSignInFormChangeNotifierState();
}

class _EmailSignInFormChangeNotifierState
    extends State<EmailSignInFormChangeNotifier> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  EmailSignInChangeModel get model => widget.model;

  Future<void> _submit() async {
    try {
      await model.submit();
      Navigator.of(context).pop();
    } on PlatformException catch (exception) {
      PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: exception,
      ).show(context);
    }
  }

  void _toggleFormType() {
    model.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _emailEditingComplete() {
    final newFocus = model.emailValidator.iSValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  List<Widget> _buildChildren() {
    return [
      _buildEmailTextField(),
      SizedBox(height: 8.0),
      _buildPasswordTextField(),
      SizedBox(height: 8.0),
      ForSubmitButton(
        text: model.primaryButtonText,
        onPressed: model.canSubmit ? _submit : null,
      ),
      SizedBox(height: 8.0),
      FlatButton(
        onPressed: !model.isLoading ? _toggleFormType : null,
        child: Text(model.secondaryButtonText),
      )
    ];
  }

  TextField _buildPasswordTextField() {
    return TextField(
      enabled: model.isLoading == false,
      onChanged: model.updatePassword,
      onEditingComplete: _submit,
      focusNode: _passwordFocusNode,
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: '******',
        errorText: model.passwordErrorText,
      ),
      textInputAction: TextInputAction.done,
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      enabled: model.isLoading == false,
      onChanged: model.updateEmail,
      onEditingComplete: () => _emailEditingComplete(),
      focusNode: _emailFocusNode,
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@example.com',
        errorText: model.emailErrorText,
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: _buildChildren(),
      ),
    );
  }
}
