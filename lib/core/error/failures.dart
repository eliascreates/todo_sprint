// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();
  String get message;
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {
  const ServerFailure();

  @override
  String get message => "Server failure occured.";
}

class CacheFailure extends Failure {
  const CacheFailure();

  @override
  String get message => "Cache failure occured.";
}

class NotFoundFailure extends Failure {
  const NotFoundFailure();

  @override
  String get message => "Not Found failure occured.";
}

class NetworkFailure extends Failure {
  const NetworkFailure();

  @override
  String get message => "Network failure occured.";
}

class DatabaseFailure extends Failure {
  const DatabaseFailure();

  @override
  String get message => "Database failure occured";
}

class ValidationFailure extends Failure {
  final String errorMessage;
  const ValidationFailure({required this.errorMessage});

  @override
  String get message => "Validation failure: $errorMessage";
}
