import 'package:flutter/material.dart';
import 'package:lit_firebase_bloc_todo/blocs/todos/todos_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_repository/todo_repository.dart';

class AddEditTodoScreen extends StatefulWidget {
  const AddEditTodoScreen({Key key, this.isEditing = false, this.todo})
      : super(key: key);

  final bool isEditing;

  final Todo todo;

  static Route route([Todo todo]) => MaterialPageRoute<void>(builder: (_) {
        final isEditing = (todo != null) ? true : false;
        return AddEditTodoScreen(isEditing: isEditing, todo: todo);
      });

  @override
  _AddEditTodoScreenState createState() => _AddEditTodoScreenState();
}

class _AddEditTodoScreenState extends State<AddEditTodoScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _save(BuildContext context) async {
    if (isEditing) {
      context.bloc<TodosBloc>().add(
            UpdateTodo(widget.todo.copyWith(task: _task, note: _note)),
          );
    } else {
      context.bloc<TodosBloc>().add(
            AddTodo(Todo(_task, note: _note)),
          );
    }
  }

  bool get isEditing => widget.isEditing;

  String _task;
  String _note;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: isEditing ? const Text('Edit') : const Text('Add'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  initialValue: isEditing ? widget.todo.task : '',
                  autofocus: !isEditing,
                  style: textTheme.headline5,
                  decoration: const InputDecoration(
                    hintText: 'What needs to be done?',
                  ),
                  validator: (val) {
                    return val.trim().isEmpty ? 'Please enter some text' : null;
                  },
                  onSaved: (value) => _task = value,
                ),
                TextFormField(
                  initialValue: isEditing ? widget.todo.note : '',
                  maxLines: 10,
                  style: textTheme.subtitle1,
                  decoration: const InputDecoration(
                    hintText: 'Additional Notes...',
                  ),
                  onSaved: (value) => _note = value,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: isEditing ? 'Save changes' : 'Add Todo',
        child: Icon(isEditing ? Icons.check : Icons.add),
        onPressed: () {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            _save(context);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
