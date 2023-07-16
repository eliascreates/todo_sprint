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
    DateTime dateTime = DateTime.parse(date);
    String formatted = DateFormat('MM/dd/yyyy h:mm a').format(dateTime);
    return formatted; //* Output: 07/16/2023 6:42 PM
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
