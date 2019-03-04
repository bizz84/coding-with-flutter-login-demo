import 'package:flutter/material.dart';
import 'package:login_demo/auth.dart';
import 'package:login_demo/home_page.dart';
import 'package:login_demo/login_page.dart';
import 'package:login_demo/auth_provider.dart';

class RootPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final BaseAuth auth = AuthProvider.of(context).auth;
    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool isLoggedIn = snapshot.hasData;
          return isLoggedIn ? HomePage() : LoginPage();
        }
        return _buildWaitingScreen();
      }
    );
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
}
