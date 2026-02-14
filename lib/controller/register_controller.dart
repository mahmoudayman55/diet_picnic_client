import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_picnic_client/components/custom_snack_bar.dart';
import 'package:diet_picnic_client/core/app_constants.dart';
import 'package:diet_picnic_client/models/client_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // 🟢 Input controllers
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // 🟢 State
  var isLoading = false.obs;

  /// 🔑 Hash password with SHA-256
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    return sha256.convert(bytes).toString();
  }

  /// 🟢 Register function
  Future<void> register() async {
    if(!formKey.currentState!.validate()){
      return;
    }
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty || phone.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      customSnackBar(
        title: "تنبيه",
        message: "من فضلك املأ جميع الحقول",
        successful: false,
      );
      return;
    }

    if (password != confirmPassword) {
      customSnackBar(
        title: "خطأ",
        message: "كلمة المرور غير متطابقة",
        successful: false,
      );
      return;
    }

    isLoading.value = true;

    try {
      // 🟢 Check if phone already exists
      final existing = await firestore
          .collection("clients")
          .where("phone", isEqualTo: phone)
          .get();

      if (existing.docs.isNotEmpty) {
        customSnackBar(
          title: "خطأ",
          message: "رقم الهاتف مستخدم بالفعل",
          successful: false,
        );
        isLoading.value = false;
        return;
      }

      // 🟢 Hash password
      final hashedPassword = _hashPassword(password);

      // 🟢 Create client model
      final client = ClientProfileModel.register(
        id: firestore.collection("clients").doc().id,
        name: name,
        phone: phone,
        password: hashedPassword, createdAt: DateTime.now(),
      );

      // 🟢 Save to Firestore
      await firestore.collection("clients").doc(client.id).set(client.toJson());
      Get.offAllNamed(AppConstants.loginPage);
      customSnackBar(
        title: "نجاح",
        message: "تم إنشاء الحساب بنجاح 🎉",
        successful: true,
      );

      // Optionally redirect to login


    } catch (e) {
      customSnackBar(
        title: "خطأ",
        message: "فشل التسجيل: $e",
        successful: false,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // nameController.dispose();
    // phoneController.dispose();
    // passwordController.dispose();
    // confirmPasswordController.dispose();
    super.onClose();
  }
}
