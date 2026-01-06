
import 'dart:developer';
import 'package:budgetly/constants/colors.dart';
import 'package:budgetly/functions/localdb.dart';
import 'package:budgetly/model/localdb.dart';
import 'package:budgetly/view/login&register/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';


class UserController extends ChangeNotifier {
  final FirebaseAuth authentication = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? uid;
  String? companyName;
  String? phone;
  String? address;
  String? email;

  // 🔐 Login Function
  Future<String?> loginUser({
    required String email,
    required String password,  
    BuildContext? context,
  }) async {
    try {
      await authentication.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      log("✅ Login success");
      notifyListeners();
      return "success";
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          backgroundColor: Appcolors.trasparantcolos,
          content: Text(e.code.toString()),
        ),
      );
      log("❌ Login error: ${e.toString()}");
    } catch (e) {
      log('❌ Login unknown error: $e');
    }
    notifyListeners();
    return null;
  }

  Future<String?> registerUser({
    required String email,
    required String password,
    required String name,
    required String address,
    required String phone,
    BuildContext? context,
  }) async {
    if (email.isEmpty ||
        phone.isEmpty ||
        address.isEmpty ||
        password.isEmpty ||
        name.isEmpty) {
      log("⚠️ One or more fields are empty.");
      return null;
    }

    try {
      UserCredential userCredential = await authentication
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      
      if (user != null) {
        // ✅ Get FCM token
        String? fcmToken = await FirebaseMessaging.instance.getToken();
        log("🔥 FCM Token: $fcmToken");

        // ✅ Store user info in Firestore
        await FirebaseFirestore.instance.collection('user').doc(user.uid).set({
          "uid": user.uid,
          "email": email,
          "company": name,
          "address": address,  
          "phone": phone,
          "fcmToken":FieldValue.arrayUnion([fcmToken]),
          "createdAt": FieldValue.serverTimestamp(),
         
        }, SetOptions(merge: true)
        );
          log("✅ User registered & token saved!");
     
        

        return "register success";
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          backgroundColor: Appcolors.trasparantcolos,
          content: Text(e.code.toString()),
        ),
      );
      log("❌ FirebaseAuthException: ${e.toString()}");
    } catch (e) {
      log("❌ Unknown registration error: $e");
    }

    return null;
  }

  // 🧾 Fetch current user metadata
  Future<void> getUserMetaData() async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      if (user != null) {
        uid = user.uid;
        final docs = await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .get(); 

        if (docs.exists) {
          companyName = docs.data()?['company'];
          address = docs.data()?['address'];
          phone = docs.data()?['phone'];
          email = docs.data()?['email'];
          log("📦 User metadata fetched: ${docs.data()}");
        }
      }
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      log("❌ Metadata error: ${e.toString()}");
    }
  }

  // 💾 Store email/password locally using Hive
  Future<void> addAccounts({
    required String email,
    required String password,
  }) async {
    final data = UserAcoountDb(email: email, password: password);
    addData(data);
  }

  // 🚪 Logout user
  void logoutUser(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
      log("🚪 Logged out");
    } catch (e) {
      log("❌ Logout Error: $e");
    }
  }
}
