import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:todo_sprint/core/network/network_info.dart';
import './network_info_test.mocks.dart';

@GenerateMocks([InternetConnectionChecker])
void main() {
  late NetworkInfoImpl network;
  late MockInternetConnectionChecker mockInternetConnectionChecker;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    network = NetworkInfoImpl(mockInternetConnectionChecker);
  });

  test('should forward call to InternetConnectionChecker.hasConnection',
      () async {
    //Arrange

    final testConnection = Future.value(true);
    when(mockInternetConnectionChecker.hasConnection).thenAnswer(
      (_) => testConnection,
    );

    //Act
    final result = network.isConnected;

    //Assert
    verify(mockInternetConnectionChecker.hasConnection);
    expect(result, testConnection);
  });
}
