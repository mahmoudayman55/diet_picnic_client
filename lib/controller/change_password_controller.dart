import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diet_picnic_client/components/custom_snack_bar.dart';
import 'package:diet_picnic_client/controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class ChangePasswordController extends GetxController {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final _firestore = FirebaseFirestore.instance;

  /// Hash password (same as register/login)
  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  /// Change password function
  Future<void> changePassword() async {
    final oldPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      showCustomSnackbar(
        title: "تنبيه",
        message: "من فضلك املأ جميع الحقول",
        successful: false,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      showCustomSnackbar(
        title: "خطأ",
        message: "كلمة المرور الجديدة وتأكيدها غير متطابقين",
        successful: false,
      );
      return;
    }

    final user = UserController.to.currentUser.value;
    if (user == null) {
      showCustomSnackbar(
        title: "خطأ",
        message: "لم يتم العثور على بيانات المستخدم",
        successful: false,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Fetch user document
      final docRef = _firestore.collection("clients").doc(user.id);
      final snapshot = await docRef.get();

      if (!snapshot.exists) {
        showCustomSnackbar(
          title: "خطأ",
          message: "المستخدم غير موجود",
          successful: false,
        );
        return;
      }

      final data = snapshot.data()!;
      final storedHashedPassword = data["password"] ?? "";

      // Verify old password
      if (storedHashedPassword != _hashPassword(oldPassword)) {
        showCustomSnackbar(
          title: "خطأ",
          message: "كلمة المرور القديمة غير صحيحة",
          successful: false,
        );
        return;
      }

      // Update password
      await docRef.update({
        "password": _hashPassword(newPassword),
      });

      showCustomSnackbar(
        title: "نجاح",
        message: "تم تغيير كلمة المرور بنجاح 🎉",
        successful: true,
      );

      // Clear fields
      oldPasswordController.clear();
      newPasswordController.clear();
      confirmPasswordController.clear();

    } catch (e) {
      showCustomSnackbar(
        title: "خطأ",
        message: "فشل تغيير كلمة المرور: $e",
        successful: false,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
