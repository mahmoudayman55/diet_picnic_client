import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

class ImgbbUploader {
  static const String _apiKey = '1356572be17a99d021294a9bd182f5fd';
  static const String _uploadUrl = 'https://api.imgbb.com/1/upload';

  static Future<String?> uploadImage(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final base64Image = base64Encode(bytes);
      final formData = FormData.fromMap({
        'key': _apiKey,
        'image': base64Image,
      });
      final response = await Dio().post(_uploadUrl, data: formData);
      if (response.statusCode == 200 && response.data['success'] == true) {
        return response.data['data']['url'];
      }
      return null;
    } catch (e) {
      print('Imgbb upload error: $e');
      return null;
    }
  }
} 
