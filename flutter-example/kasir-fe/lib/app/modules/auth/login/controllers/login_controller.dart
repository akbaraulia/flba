import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kasir/app/service/api_endpoint.dart';

class AuthRepository {
  Future<http.Response> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoint.login),
        body: {
          'email': email,
          'password': password,
        },
      );
      return response;
    } catch (e) {
      throw Exception('Failed to connect to server');
    }
  }
}

class LoginController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  final box = GetStorage();

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    try {
      final response = await _authRepository.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        await box.write('token', responseData['access_token']);
        await box.write('user', responseData['user']);
        await box.write('user_id', responseData['user']['id']);
        print('User ID: ${box.read('user_id')}');

        print('Token dari response: ${responseData['access_token']}');

        String role = responseData['user']['role'];
        switch (role) {
          case 'admin':
            Get.offAllNamed('/dashboard_admin');
            break;
          case 'kasir':
            Get.offAllNamed('/dashboard_kasir');
            break;
          default:
            showError('Role tidak dikenali');
        }
      } else {
        showError(_handleErrorResponse(response));
      }
    } catch (e) {
      showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    box.erase();
    Get.offAllNamed('/login');
  }

  void showError(String message) {
    Get.snackbar('Error', message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white);
  }

  String _handleErrorResponse(http.Response response) {
    try {
      final responseBody = jsonDecode(response.body);
      return responseBody['message'] ?? 'Unknown error occurred';
    } catch (_) {
      return 'Error ${response.statusCode}: Unable to parse response';
    }
  }
}
