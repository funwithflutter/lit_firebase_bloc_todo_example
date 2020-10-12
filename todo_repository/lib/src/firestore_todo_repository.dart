// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'dart:async';

import 'package:meta/meta.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'entities/entities.dart';
import 'models/models.dart';
import 'todo_repository.dart';

class FirestoreTodoRepository implements TodoRepository {
  FirestoreTodoRepository({@required this.userId})
      : assert(userId != null),
        todoCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('todos');

  final String userId;

  final CollectionReference todoCollection;

  @override
  Future<void> addNewTodo(Todo todo) {
    print(userId);
    return todoCollection.add(todo.toEntity().toDocument());
  }

  @override
  Future<void> deleteTodo(Todo todo) async {
    return todoCollection.doc(todo.id).delete();
  }

  @override
  Stream<List<Todo>> todos() {
    return todoCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Todo.fromEntity(TodoEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<void> updateTodo(Todo update) {
    return todoCollection.doc(update.id).update(update.toEntity().toDocument());
  }
}
