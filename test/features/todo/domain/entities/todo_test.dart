import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:todo_sprint/features/todo/domain/entities/todo.dart';

void main() {
  late Todo todo;

  setUp(() {
    todo = Todo(
      id: '1',
      title: 'Test Title',
      description: 'Test Description',
      dateCreated: "2023-07-16T18:42:04.879Z",
      dateUpdated: "2023-07-16T18:42:04.879Z",
    );
  });

  group('formatUpdatedDate', () {
    test('should return "Today - h:mm a" for the current date', () {
      //Arrange
      DateTime now = DateTime.now();
      final testTodo = todo.copyWith(dateUpdated: now.toIso8601String());

      //Act
      String result = testTodo.formatUpdatedDate();

      //Assert
      String expectedString = 'Today - ${DateFormat('h:mm a').format(now)}';
      expect(result, expectedString);
    });

    test('should return "Yesterday - h:mm a" for the date one day ago', () {
      //Arrange - 23:59 because 00:00 is technically a new day
      DateTime now =
          DateTime.now().subtract(const Duration(hours: 23, minutes: 59));
      final testTodo = todo.copyWith(dateUpdated: now.toIso8601String());

      //Act
      String result = testTodo.formatUpdatedDate();

      //Assert
      String expectedString = 'Yesterday - ${DateFormat('h:mm a').format(now)}';
      expect(result, expectedString);
    });

    test('should return "X days ago" for dates within the last week', () {
      //Arrange
      DateTime now = DateTime.now().subtract(const Duration(days: 6));
      final testTodo = todo.copyWith(dateUpdated: now.toIso8601String());

      //Act
      String result = testTodo.formatUpdatedDate();

      //Assert
      expect(result, '6 days ago - ${DateFormat('h:mm a').format(now)}');
    });

    test('should return the proper format for dates older than a week', () {
      //Arrange
      String dateString = "2023-07-01T18:42:04.879Z";
      final testTodo = todo.copyWith(dateUpdated: dateString);

      //Act
      String formattedDate = testTodo.formatUpdatedDate();

      //Assert
      expect(formattedDate, 'Jul 1, 2023, 6:42 PM');
    });
  });

  group('formatCreatedDate', () {
    test('should return the proper format for dates older than a year', () {
      //Arrange
      String dateString = "2022-07-01T18:42:04.879Z";
      final testTodo = todo.copyWith(dateCreated: dateString);

      //Act
      String formattedDate = testTodo.formatCreatedDate();

      //Assert
      expect(formattedDate, '1 Jul, 2022, 6:42 PM');
    });

    test('should return the proper format for dates within current year', () {
      //Arrange
      String dateString = "2023-07-01T18:42:04.879Z";
      final testTodo = todo.copyWith(dateCreated: dateString);

      //Act
      String formattedDate = testTodo.formatCreatedDate();

      //Assert
      expect(formattedDate, '1 Jul, 6:42 PM');
    });
  });
}
