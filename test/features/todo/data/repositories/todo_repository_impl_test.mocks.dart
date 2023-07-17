// Mocks generated by Mockito 5.4.2 from annotations
// in todo_sprint/test/features/todo/data/repositories/todo_repository_impl_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:mockito/mockito.dart' as _i1;
import 'package:todo_sprint/core/network/network_info.dart' as _i6;
import 'package:todo_sprint/features/todo/data/datasources/todo_local_data_source.dart'
    as _i3;
import 'package:todo_sprint/features/todo/data/datasources/todo_remote_data_source.dart'
    as _i5;
import 'package:todo_sprint/features/todo/data/models/todo_model.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeTodoModel_0 extends _i1.SmartFake implements _i2.TodoModel {
  _FakeTodoModel_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [TodoLocalDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockTodoLocalDataSource extends _i1.Mock
    implements _i3.TodoLocalDataSource {
  MockTodoLocalDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<List<_i2.TodoModel>> getAllTodos() => (super.noSuchMethod(
        Invocation.method(
          #getAllTodos,
          [],
        ),
        returnValue: _i4.Future<List<_i2.TodoModel>>.value(<_i2.TodoModel>[]),
      ) as _i4.Future<List<_i2.TodoModel>>);
  @override
  _i4.Future<_i2.TodoModel> getTodoById(String? todoId) => (super.noSuchMethod(
        Invocation.method(
          #getTodoById,
          [todoId],
        ),
        returnValue: _i4.Future<_i2.TodoModel>.value(_FakeTodoModel_0(
          this,
          Invocation.method(
            #getTodoById,
            [todoId],
          ),
        )),
      ) as _i4.Future<_i2.TodoModel>);
  @override
  _i4.Future<void> createTodo(_i2.TodoModel? todo) => (super.noSuchMethod(
        Invocation.method(
          #createTodo,
          [todo],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<void> updateTodo(_i2.TodoModel? todo) => (super.noSuchMethod(
        Invocation.method(
          #updateTodo,
          [todo],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
  @override
  _i4.Future<void> deleteTodo(String? todoId) => (super.noSuchMethod(
        Invocation.method(
          #deleteTodo,
          [todoId],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}

/// A class which mocks [TodoRemoteDataSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockTodoRemoteDataSource extends _i1.Mock
    implements _i5.TodoRemoteDataSource {
  MockTodoRemoteDataSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<List<_i2.TodoModel>> getAllTodos() => (super.noSuchMethod(
        Invocation.method(
          #getAllTodos,
          [],
        ),
        returnValue: _i4.Future<List<_i2.TodoModel>>.value(<_i2.TodoModel>[]),
      ) as _i4.Future<List<_i2.TodoModel>>);
  @override
  _i4.Future<_i2.TodoModel> getTodoById(String? todoId) => (super.noSuchMethod(
        Invocation.method(
          #getTodoById,
          [todoId],
        ),
        returnValue: _i4.Future<_i2.TodoModel>.value(_FakeTodoModel_0(
          this,
          Invocation.method(
            #getTodoById,
            [todoId],
          ),
        )),
      ) as _i4.Future<_i2.TodoModel>);
  @override
  _i4.Future<_i2.TodoModel> createTodo(_i2.TodoModel? todo) =>
      (super.noSuchMethod(
        Invocation.method(
          #createTodo,
          [todo],
        ),
        returnValue: _i4.Future<_i2.TodoModel>.value(_FakeTodoModel_0(
          this,
          Invocation.method(
            #createTodo,
            [todo],
          ),
        )),
      ) as _i4.Future<_i2.TodoModel>);
  @override
  _i4.Future<_i2.TodoModel> updateTodo(_i2.TodoModel? todo) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateTodo,
          [todo],
        ),
        returnValue: _i4.Future<_i2.TodoModel>.value(_FakeTodoModel_0(
          this,
          Invocation.method(
            #updateTodo,
            [todo],
          ),
        )),
      ) as _i4.Future<_i2.TodoModel>);
  @override
  _i4.Future<String> deleteTodo(String? todoId) => (super.noSuchMethod(
        Invocation.method(
          #deleteTodo,
          [todoId],
        ),
        returnValue: _i4.Future<String>.value(''),
      ) as _i4.Future<String>);
}

/// A class which mocks [NetworkInfo].
///
/// See the documentation for Mockito's code generation for more information.
class MockNetworkInfo extends _i1.Mock implements _i6.NetworkInfo {
  MockNetworkInfo() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<bool> get isConnected => (super.noSuchMethod(
        Invocation.getter(#isConnected),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);
}