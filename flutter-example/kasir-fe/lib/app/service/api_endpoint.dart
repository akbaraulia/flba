import 'package:kasir/core/base_api.dart';

class ApiEndpoint {
  static const String baseUrl = BaseApi.baseUrl;

  static String get login => '$baseUrl/login';
  static String get register => '$baseUrl/register';
  static String get product => '$baseUrl/products';
  static String get imageBase => '$baseUrl/storage/images';
  static String get user => '$baseUrl/users';
  static String get member => '$baseUrl/members';
  static String get payment => '$baseUrl/payments';
}
