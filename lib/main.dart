import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lit_firebase_auth/lit_firebase_auth.dart';
import 'package:lit_firebase_bloc_todo/screens/auth/auth.dart';
import 'package:lit_firebase_bloc_todo/screens/home/home.dart';
import 'package:todo_repository/todo_repository.dart';

import 'blocs/todos/todos_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AppInit());
}

class AppInit extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return LitAuthInit(
            authProviders: const AuthProviders(
              emailAndPassword: true, // enabled by default
            ),
            // Wrap the MaterialApp with the relevant Blocs and Repositories
            child: _AuthStateBlocProvider(
              child: MaterialApp(
                title: 'Material App',
                themeMode: ThemeMode.light,
                darkTheme: ThemeData.dark(),
                theme: ThemeData(
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                home: const LitAuthState(
                  authenticated: HomeScreen(),
                  unauthenticated: AuthScreen(),
                ),
              ),
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to
        // complete
        return const _LoadingWidget();
      },
    );
  }
}

/// This widget uses the Lit Firebase Auth package to listen to updates
/// to the current signed in user. If the user is signed in then the
/// `FirestoreTodoRepository` and `TodosBloc` is created with the current
/// `user.uid`.
///
/// The [child] widget is wrapped with a `RepositoryProvider` and
/// `BlocProvider`, and can now be used throughout the application.
///
/// This is a seperate widget to cache the [child] value.
class _AuthStateBlocProvider extends StatelessWidget {
  const _AuthStateBlocProvider({Key key, @required this.child})
      : assert(child != null),
        super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return context.watchSignedInUser().when(
      // Signed-in
      (user) {
        final todoRepository = FirestoreTodoRepository(userId: user.uid);
        return RepositoryProvider.value(
          value: todoRepository,
          child: BlocProvider(
            create: (_) {
              return TodosBloc(
                todoRepository: todoRepository,
              )..add(LoadTodos());
            },
            child: child,
          ),
        );
      },
      // Not Signed-in
      empty: () => child,
      // Loading
      initializing: () => const _LoadingWidget(),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
