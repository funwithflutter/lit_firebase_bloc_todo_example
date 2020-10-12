import 'package:flutter/material.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'package:lit_firebase_bloc_todo/screens/todos/todos.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen();

  static Route get route =>
      MaterialPageRoute<void>(builder: (_) => const HomeScreen());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        centerTitle: false,
        actions: [
          const _SignOutButton(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push((AddEditTodoScreen.route()));
        },
        child: const Icon(Icons.add),
      ),
      body: const TodosList(),
    );
  }
}

class _SignOutButton extends StatelessWidget {
  const _SignOutButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FlatButton(
        onPressed: () {
          context.signOut();
        },
        child: const Text(
          'SIGN OUT',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
