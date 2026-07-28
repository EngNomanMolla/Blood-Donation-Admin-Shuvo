import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../routes/app_pages.dart';

class AuthController extends GetxController {
  // Login Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  // Registration Controllers
  final registerNameController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerPhoneController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final registerConfirmPasswordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isRegisterPasswordVisible = false.obs;
  final isRegisterConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;

  final GetConnect _connect = GetConnect();
  final String baseUrl = 'http://www.bloodlinkonline.xyz/api/v1';

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    registerNameController.dispose();
    registerEmailController.dispose();
    registerPhoneController.dispose();
    registerPasswordController.dispose();
    registerConfirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRegisterPasswordVisibility() {
    isRegisterPasswordVisible.value = !isRegisterPasswordVisible.value;
  }

  void toggleRegisterConfirmPasswordVisibility() {
    isRegisterConfirmPasswordVisible.value = !isRegisterConfirmPasswordVisible.value;
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter both email and password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await _connect.post(
        '$baseUrl/admin/login',
        {
          'email': email,
          'password': password,
        },
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.status.isOk && response.body != null) {
        final body = response.body as Map<String, dynamic>;
        
        // Safe check for token in standard backend formats
        String? token;
        if (body['token'] != null) {
          token = body['token'].toString();
        } else if (body['data'] != null && body['data'] is Map && body['data']['token'] != null) {
          token = body['data']['token'].toString();
        }

        // Store session token
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('admin_token', token ?? 'authenticated');

        Get.snackbar(
          'Login Success',
          'Welcome back, administrator!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green,
        );

        // Redirect to main panel and clear route stack
        Get.offAllNamed(Routes.ADMIN_PANEL);
      } else {
        String errorMsg = 'Invalid email or password';
        if (response.body != null && response.body is Map) {
          final errorBody = response.body as Map;
          if (errorBody['message'] != null) {
            errorMsg = errorBody['message'].toString();
          }
        } else if (response.statusText != null) {
          errorMsg = response.statusText!;
        }

        Get.snackbar(
          'Login Failed',
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register() async {
    final name = registerNameController.text.trim();
    final email = registerEmailController.text.trim();
    final phone = registerPhoneController.text.trim();
    final password = registerPasswordController.text;
    final passwordConfirm = registerConfirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return;
    }

    if (password != passwordConfirm) {
      Get.snackbar(
        'Validation Error',
        'Passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await _connect.post(
        '$baseUrl/admin/register',
        {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'password_confirmation': passwordConfirm,
        },
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.status.isOk && response.body != null) {
        final body = response.body as Map<String, dynamic>;
        
        // Auto-login if backend returns a token, otherwise direct to Login view
        String? token;
        if (body['token'] != null) {
          token = body['token'].toString();
        } else if (body['data'] != null && body['data'] is Map && body['data']['token'] != null) {
          token = body['data']['token'].toString();
        }

        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('admin_token', token);
          
          Get.snackbar(
            'Success',
            'Registration successful! Welcome to the portal.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withValues(alpha: 0.1),
            colorText: Colors.green,
          );
          Get.offAllNamed(Routes.ADMIN_PANEL);
        } else {
          Get.snackbar(
            'Success',
            'Admin registered successfully! Please log in.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withValues(alpha: 0.1),
            colorText: Colors.green,
          );
          
          // Clear registration inputs
          registerNameController.clear();
          registerEmailController.clear();
          registerPhoneController.clear();
          registerPasswordController.clear();
          registerConfirmPasswordController.clear();
          
          Get.offNamed(Routes.LOGIN);
        }
      } else {
        String errorMsg = 'Registration failed';
        if (response.body != null && response.body is Map) {
          final errorBody = response.body as Map;
          if (errorBody['message'] != null) {
            errorMsg = errorBody['message'].toString();
          } else if (errorBody['errors'] != null && errorBody['errors'] is Map) {
            // Flatten database validation errors
            final errors = errorBody['errors'] as Map;
            errorMsg = errors.values.map((e) => e.toString()).join('\n');
          }
        } else if (response.statusText != null) {
          errorMsg = response.statusText!;
        }

        Get.snackbar(
          'Registration Failed',
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('admin_token');

      if (token != null) {
        // Hitting backend logout endpoint
        await _connect.post(
          '$baseUrl/admin/logout',
          {},
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }

      await prefs.remove('admin_token');
      
      // Clear input fields
      emailController.clear();
      passwordController.clear();

      Get.snackbar(
        'Logged Out',
        'You have been logged out successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue.withValues(alpha: 0.1),
        colorText: Colors.blue,
      );

      // Return to Login view
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to log out: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
