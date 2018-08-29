

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:login_demo/auth.dart';
import 'package:login_demo/auth_provider.dart';
import 'package:login_demo/login_page.dart';
import 'package:mockito/mockito.dart';

class MockAuth extends Mock implements BaseAuth {}

void main() {

  Widget makeTestableWidget({Widget child, BaseAuth auth}) {
    return AuthProvider(
      auth: auth,
      child: MaterialApp(
        home: child,
      ),
    );
  }

  testWidgets('email or password is empty, does not sign in', (WidgetTester tester) async {

    MockAuth mockAuth = MockAuth();

    bool didSignIn = false;
    LoginPage page = LoginPage(onSignedIn: () => didSignIn = true);

    await tester.pumpWidget(makeTestableWidget(child: page, auth: mockAuth));

    await tester.tap(find.byKey(Key('signIn')));

    verifyNever(mockAuth.signInWithEmailAndPassword('', ''));
    expect(didSignIn, false);
  });

  testWidgets('non-empty email and password, valid account, call sign in, succeed', (WidgetTester tester) async {

    MockAuth mockAuth = MockAuth();
    when(mockAuth.signInWithEmailAndPassword('email', 'password')).thenAnswer((invocation) => Future.value('uid'));

    bool didSignIn = false;
    LoginPage page = LoginPage(onSignedIn: () => didSignIn = true);

    await tester.pumpWidget(makeTestableWidget(child: page, auth: mockAuth));
    
    Finder emailField = find.byKey(Key('email'));
    await tester.enterText(emailField, 'email');

    Finder passwordField = find.byKey(Key('password'));
    await tester.enterText(passwordField, 'password');

    await tester.tap(find.byKey(Key('signIn')));

    verify(mockAuth.signInWithEmailAndPassword('email', 'password')).called(1);
    expect(didSignIn, true);
    
  });

  testWidgets('non-empty email and password, valid account, call sign in, fails', (WidgetTester tester) async {

    MockAuth mockAuth = MockAuth();
    when(mockAuth.signInWithEmailAndPassword('email', 'password')).thenThrow(StateError('invalid credentials'));

    bool didSignIn = false;
    LoginPage page = LoginPage(onSignedIn: () => didSignIn = true);

    await tester.pumpWidget(makeTestableWidget(child: page, auth: mockAuth));

    Finder emailField = find.byKey(Key('email'));
    await tester.enterText(emailField, 'email');

    Finder passwordField = find.byKey(Key('password'));
    await tester.enterText(passwordField, 'password');

    await tester.tap(find.byKey(Key('signIn')));

    verify(mockAuth.signInWithEmailAndPassword('email', 'password')).called(1);
    expect(didSignIn, false);

  });

}