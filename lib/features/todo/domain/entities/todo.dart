// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Todo extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final String dateCreated;
  final String dateUpdated;

  String formatDate(String date) {
    DateTime now = DateTime.now();
    DateTime dateTime = DateTime.parse(date);

    // Calculates the difference in days between now and the input date
    int differenceInDays = now.difference(dateTime).inDays.abs();

    if (differenceInDays == 0) {
      return 'Today - ${DateFormat('h:mm a').format(dateTime)}';
    } else if (differenceInDays == 1) {
      return 'Yesterday - ${DateFormat('h:mm a').format(dateTime)}';
    } else if (differenceInDays <= 7) {
      return '$differenceInDays days ago';
    } else {
      // For dates older than a week, it will use the proper format
      return DateFormat('MMM d, y, h:mm a').format(dateTime);
    }
  }

  const Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.dateCreated,
    required this.dateUpdated,
    this.isCompleted = false,
  });

  @override
  List<Object?> get props =>
      [id, title, description, isCompleted, dateCreated, dateUpdated];
}
