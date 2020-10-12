import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lit_firebase_bloc_todo/blocs/blocs.dart';
import 'package:lit_firebase_bloc_todo/screens/todos/todos.dart';
import 'package:todo_repository/todo_repository.dart';

class TodosList extends StatelessWidget {
  const TodosList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodosBloc, TodosState>(
      builder: (context, state) {
        if (state is TodosLoading) {
          return const _Loading();
        }
        if (state is TodosLoaded) {
          if (state.todos.isEmpty) {
            return const _NoTodos();
          }
          return _Todos(todos: state.todos);
        }
        return const _CouldNotLoad();
      },
    );
  }
}

class _Todos extends StatelessWidget {
  const _Todos({
    @required this.todos,
    Key key,
  })  : assert(todos != null),
        super(key: key);

  final List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return _TodoItem(
            todo: todos[index],
          );
        },
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _NoTodos extends StatelessWidget {
  const _NoTodos({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('No todos yet. Add some :)'));
  }
}

class _CouldNotLoad extends StatelessWidget {
  const _CouldNotLoad({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Could not load todos:('));
  }
}

class _TodoItem extends StatelessWidget {
  const _TodoItem({Key key, this.todo}) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(color: Colors.red),
      key: ValueKey(todo.id),
      onDismissed: (direction) {
        context.bloc<TodosBloc>().add(DeleteTodo(todo));
      },
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(AddEditTodoScreen.route(todo));
        },
        child: ListTile(
          title: Text(todo.task),
          trailing: Checkbox(
            value: todo.complete,
            onChanged: (val) {
              context.bloc<TodosBloc>().add(UpdateTodo(
                    todo.copyWith(
                      complete: !todo.complete,
                    ),
                  ));
            },
          ),
        ),
      ),
    );
  }
}
