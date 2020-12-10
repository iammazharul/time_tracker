import 'package:time_tracker/app/sign_in/validators.dart';
import 'package:time_tracker/common_widget/for_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/services/auth.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidator {
  final AuthBase auth;

  EmailSignInForm({Key key, this.auth}) : super(key: key);
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  String get _email => _emailController.text;
  String get _password => _passwordController.text;

  EmailSignInFormType _formType = EmailSignInFormType.signIn;

  void _submit() async {
    try {
      if (_formType == EmailSignInFormType.signIn) {
        await widget.auth.signInWithEmailAndPassword(_email, _password);
      } else {
        await widget.auth.createUserWithEmailAndPassword(_email, _password);
      }
      Navigator.of(context).pop();
    } catch (e) {
      print(e.toString());
    }
  }

  void _toggleFormType() {
    setState(() {
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
      _emailController.clear();
      _passwordController.clear();
    });
  }

  _updateState() {
    setState(() {});
  }

  void _emailEditingComplete() {
    FocusScope.of(context).requestFocus(_passwordFocusNode);
  }

  List<Widget> _buildChildren() {
    final primaryText = _formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
    bool submitEnalble = widget.emailValidator.iSValid(_email) &&
        widget.passwordValidator.iSValid(_password);
    return [
      _buildEmailTextField(),
      SizedBox(height: 8.0),
      _buildPasswordTextField(),
      SizedBox(height: 8.0),
      ForSubmitButton(
        text: primaryText,
        onPressed: submitEnalble ? _submit : null,
      ),
      SizedBox(height: 8.0),
      FlatButton(
        onPressed: _toggleFormType,
        child: Text(secondaryText),
      )
    ];
  }

  TextField _buildPasswordTextField() {
    bool passwordValid = widget.emailValidator.iSValid(_email);

    return TextField(
      onChanged: (password) => _updateState(),
      onEditingComplete: _submit,
      focusNode: _passwordFocusNode,
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: '******',
        errorText: passwordValid ? null : widget.invalidPasswordErrorText,
      ),
      textInputAction: TextInputAction.done,
    );
  }

  TextField _buildEmailTextField() {
    bool emailValid = widget.emailValidator.iSValid(_email);
    return TextField(
      onChanged: (email) => _updateState(),
      onEditingComplete: _emailEditingComplete,
      focusNode: _emailFocusNode,
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'test@example.com',
        errorText: emailValid ? null : widget.invalidEmailErrorText,
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
