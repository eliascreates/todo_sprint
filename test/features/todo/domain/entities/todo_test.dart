import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:todo_sprint/features/todo/domain/entities/todo.dart';

void main() {
  group('formatDate', () {
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
    test('should return "Today" for the current date', () {
      //Arrange
      DateTime now = DateTime.now();

      //Act
      String result = todo.formatDate(now.toIso8601String());

      //Assert
      String expectedString = 'Today - ${DateFormat('h:mm a').format(now)}';
      expect(result, expectedString);
    });

    test('should return "Yesterday" for the date one day ago', () {
      //Arrange
      DateTime now = DateTime.now();

      //Act
      DateTime yesterday = now.subtract(const Duration(days: 1));
      String result = todo.formatDate(yesterday.toIso8601String());

      //Assert
      String expectedString =
          'Yesterday - ${DateFormat('h:mm a').format(yesterday)}';

      expect(result, expectedString);
    });

    test('should return "X days ago" for dates within the last week', () {
      //Arrange
      DateTime now = DateTime.now();
      
      //Act
      DateTime sixDaysAgo = now.subtract(const Duration(days: 6));
      String result =
          todo.formatDate(sixDaysAgo.toUtc().toIso8601String());
      
      //Assert
      expect(result, '6 days ago');
    });

    test('should return the proper format for dates older than a week', () {
      //Arrange
      String dateString = "2023-07-01T18:42:04.879Z";
      
      //Act
      String formattedDate = todo.formatDate(dateString);
      
      //Assert
      expect(formattedDate, 'Jul 1, 2023, 6:42 PM');
    });
  });
}
