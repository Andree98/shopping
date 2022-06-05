import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shopping/domain/home/home_interface.dart';

class MockHttpClient extends Mock implements Client {}

class MockHomeInterface extends Mock implements HomeInterface {}