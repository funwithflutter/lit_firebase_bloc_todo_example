import 'package:flutter/material.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LitAuth(
          config: AuthConfig(
            title: Text(
              '🔥Lit Firebase Todo with Bloc!🔥',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline4,
            ),
            googleButton: const GoogleButtonConfig.light(),
            appleButton: const AppleButtonConfig.dark(),
          ),
        ),
      ),
    );
  }
}
