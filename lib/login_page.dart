import 'package:flutter/material.dart';
import 'package:login_demo/auth_provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.onSignedIn});
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

enum FormType {
  login,
  register,
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  FormType _formType = FormType.login;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      try {
        var auth = AuthProvider.of(context).auth;
        if (_formType == FormType.login) {
          String userId =
              await auth.signInWithEmailAndPassword(_email, _password);
          print('Signed in: $userId');
        } else {
          String userId = await auth
              .createUserWithEmailAndPassword(_email, _password);
          print('Registered user: $userId');
        }
        widget.onSignedIn();
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter login demo'),
        ),
        body: Container(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: buildInputs() + buildSubmitButtons(),
              ),
            )));
  }

  List<Widget> buildInputs() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Email'),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value,
      ),
    ];
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        RaisedButton(
          child: Text('Login', style: TextStyle(fontSize: 20.0)),
          onPressed: validateAndSubmit,
        ),
        FlatButton(
          child: Text('Create an account',
              style: TextStyle(fontSize: 20.0)),
          onPressed: moveToRegister,
        ),
      ];
    } else {
      return [
        RaisedButton(
          child: Text('Create an account',
              style: TextStyle(fontSize: 20.0)),
          onPressed: validateAndSubmit,
        ),
        FlatButton(
          child: Text('Have an account? Login',
              style: TextStyle(fontSize: 20.0)),
          onPressed: moveToLogin,
        ),
      ];
    }
  }
}
