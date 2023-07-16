import 'package:flutter_test/flutter_test.dart';
import 'package:todo_sprint/features/todo/domain/entities/todo.dart';

void main() {
  group('formatData', () {
    late Todo todo;

    setUp(() {
      todo = const Todo(
        id: '1',
        title: 'Test Title',
        description: 'Test Description',
        dateCreated: "2023-07-16T18:42:04.879Z",
        dateUpdated: "2023-07-16T18:42:04.879Z",
      );
    });

    test('Should return a well formatted date (MM/dd/yyyy h:mm a)', () {
      //Act
      final result = todo.formatDate(todo.dateCreated);

      //Assert 7/16/2023 6:42 PM
      expect(result, '07/16/2023 6:42 PM');
    });
  });
}
