import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/banner_model.dart';

class BannerController extends GetxController {
  final bannersList = <BannerModel>[].obs;
  final isLoading = false.obs;
  final isSubmitting = false.obs;

  // Selected image for creating/updating banner
  final Rx<XFile?> selectedImage = Rx<XFile?>(null);
  final ImagePicker _picker = ImagePicker();

  final GetConnect _connect = GetConnect();
  final String baseUrl = 'http://www.bloodlinkonline.xyz/api/v1';

  @override
  void onInit() {
    super.onInit();
    fetchBanners();
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (picked != null) {
        selectedImage.value = picked;
      }
    } catch (e) {
      Get.snackbar(
        'Image Error',
        'Failed to select image: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
    }
  }

  void clearSelectedImage() {
    selectedImage.value = null;
  }

  Future<void> fetchBanners() async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('admin_token');

      final response = await _connect.get(
        '$baseUrl/admin/banners',
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.status.isOk && response.body != null) {
        final dynamic responseData = response.body;
        List<dynamic>? rawList;

        if (responseData is List) {
          rawList = responseData;
        } else if (responseData is Map) {
          if (responseData['data'] != null) {
            if (responseData['data'] is List) {
              rawList = responseData['data'] as List;
            } else if (responseData['data'] is Map &&
                responseData['data']['data'] is List) {
              rawList = responseData['data']['data'] as List;
            }
          }
        }

        if (rawList != null) {
          bannersList.value = rawList
              .map((e) => BannerModel.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList();
        } else {
          bannersList.clear();
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to load banners: ${response.statusText}',
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

  Future<bool> createBanner({
    required String title,
    required XFile imageFile,
    String? link,
    required int isActive,
    required int order,
  }) async {
    isSubmitting.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('admin_token');

      final uri = Uri.parse('$baseUrl/admin/banners');
      final request = http.MultipartRequest('POST', uri);

      // Headers
      request.headers.addAll({
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      });

      // Form text fields
      request.fields['title'] = title;
      if (link != null && link.isNotEmpty) {
        request.fields['link'] = link;
      }
      request.fields['is_active'] = isActive.toString();
      request.fields['order'] = order.toString();

      // Form image file
      final bytes = await imageFile.readAsBytes();
      final multipartFile = http.MultipartFile.fromBytes(
        'image',
        bytes,
        filename: imageFile.name.isNotEmpty ? imageFile.name : 'banner.jpg',
      );
      request.files.add(multipartFile);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        Get.snackbar(
          'Success',
          'Banner created successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green,
        );
        clearSelectedImage();
        await fetchBanners();
        return true;
      } else {
        String errorMsg = 'Failed to create banner';
        try {
          final errorBody = jsonDecode(response.body);
          if (errorBody is Map && errorBody['message'] != null) {
            errorMsg = errorBody['message'].toString();
          }
        } catch (_) {}
        Get.snackbar(
          'Error',
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> updateBanner(
    int id, {
    required String title,
    XFile? newImageFile,
    String? link,
    required int isActive,
    required int order,
  }) async {
    isSubmitting.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('admin_token');

      final uri = Uri.parse('$baseUrl/admin/banners/$id');
      final request = http.MultipartRequest('POST', uri);

      // Headers
      request.headers.addAll({
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      });

      // Form text fields + method spoofing for Laravel/REST API multipart update
      request.fields['_method'] = 'PUT';
      request.fields['title'] = title;
      if (link != null) {
        request.fields['link'] = link;
      }
      request.fields['is_active'] = isActive.toString();
      request.fields['order'] = order.toString();

      // If new image was chosen
      if (newImageFile != null) {
        final bytes = await newImageFile.readAsBytes();
        final multipartFile = http.MultipartFile.fromBytes(
          'image',
          bytes,
          filename: newImageFile.name.isNotEmpty ? newImageFile.name : 'banner.jpg',
        );
        request.files.add(multipartFile);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        Get.snackbar(
          'Success',
          'Banner updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green,
        );
        clearSelectedImage();
        await fetchBanners();
        return true;
      } else {
        String errorMsg = 'Failed to update banner';
        try {
          final errorBody = jsonDecode(response.body);
          if (errorBody is Map && errorBody['message'] != null) {
            errorMsg = errorBody['message'].toString();
          }
        } catch (_) {}
        Get.snackbar(
          'Error',
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<bool> deleteBanner(int id) async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('admin_token');

      final response = await _connect.delete(
        '$baseUrl/admin/banners/$id',
        headers: {
          'Accept': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      if (response.status.isOk) {
        Get.snackbar(
          'Success',
          'Banner deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withValues(alpha: 0.1),
          colorText: Colors.green,
        );
        await fetchBanners();
        return true;
      } else {
        String errorMsg = 'Failed to delete banner';
        if (response.body != null && response.body is Map) {
          final errorBody = response.body as Map;
          if (errorBody['message'] != null) {
            errorMsg = errorBody['message'].toString();
          }
        } else if (response.statusText != null) {
          errorMsg = response.statusText!;
        }
        Get.snackbar(
          'Error',
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.1),
          colorText: Colors.red,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        colorText: Colors.red,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
