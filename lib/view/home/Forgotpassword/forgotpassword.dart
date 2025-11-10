import 'package:budgetly/constants/colors.dart';
import 'package:budgetly/view/login&register/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  void sendResetLink(BuildContext context) async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter your email")),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password reset link sent to $email")),
      );

      await Future.delayed(Duration(seconds: 2));
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Appcolors.backgroundblue,
      appBar: AppBar(
        backgroundColor: Appcolors.backgroundblue,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Forgot Password",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: size.width,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Reset your password",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Appcolors.backgroundblue,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Enter your registered email below to receive password reset instructions.",
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
            SizedBox(height: 30),
            TextField(
              controller: emailController,
              style: TextStyle(color: Appcolors.backgroundblue),
              decoration: InputDecoration(
                labelText: "Email",
                labelStyle: TextStyle(color: Appcolors.backgroundblue),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.email, color: Appcolors.backgroundblue),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () => sendResetLink(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Appcolors.backgroundblue, Colors.lightBlueAccent],
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Text(
                    "Send Reset Link",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
