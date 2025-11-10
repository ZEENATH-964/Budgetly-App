// // //...........
// // import 'package:flutter/material.dart';
// // import 'package:provider/provider.dart';
// // import 'package:shersoft/constants/colors.dart';
// // import 'package:shersoft/view/login&register/login.dart';
// // import 'package:video_player/video_player.dart';
// // import 'package:shersoft/controller/login.dart';
// // import 'package:shersoft/controller/localdb.dart';
// // import 'package:shersoft/model/localdb.dart';
// // import 'package:shersoft/view/home/homepage.dart';
// // import 'package:shersoft/view/login&register/widget/widget.dart';

// // class RegisterPage extends StatefulWidget {
// //   const RegisterPage({super.key});

// //   @override
// //   State<RegisterPage> createState() => _RegisterPageState();
// // }

// // class _RegisterPageState extends State<RegisterPage> {
// //   final TextEditingController emailController = TextEditingController();
// //   final TextEditingController passwordController = TextEditingController();
// //   final TextEditingController nameController = TextEditingController();
// //   final TextEditingController phoneController = TextEditingController();
// //   final TextEditingController addressController = TextEditingController();

// //   late VideoPlayerController _videoController;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _videoController = VideoPlayerController.asset('asset/register.mp4')
// //       ..initialize().then((_) {
// //         _videoController.setLooping(true);
// //         _videoController.setVolume(0.0);
// //         _videoController.play();
// //         setState(() {});
// //       });
// //   }

// //   @override
// //   void dispose() {
// //     _videoController.dispose();
// //     emailController.dispose();
// //     passwordController.dispose();
// //     nameController.dispose();
// //     phoneController.dispose();
// //     addressController.dispose();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Stack(
// //         children: [
// //           _videoController.value.isInitialized
// //               ? SizedBox.expand(
// //                   child: FittedBox(
// //                     fit: BoxFit.cover,
// //                     child: SizedBox(
// //                       width: _videoController.value.size.width,
// //                       height: _videoController.value.size.height,
// //                       child: VideoPlayer(_videoController),
// //                     ),
// //                   ),
// //                 )
// //               : Container(color: Colors.black),
// //           Container(color: Colors.black.withOpacity(0.5)),
// //           SingleChildScrollView(
// //             child: Container(
// //               height: MediaQuery.of(context).size.height,
// //               padding: const EdgeInsets.all(20),
// //               child: Center(
// //                 child: Container(
// //                   width: double.infinity,
// //                   decoration: BoxDecoration(
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                   padding: const EdgeInsets.all(20),
// //                   child: Consumer<UserController>(
// //                     builder: (context, provider, child) {
// //                       return Column(
// //                         mainAxisSize: MainAxisSize.min,
// //                         children: [
// //                           const SizedBox(height: 20),
// //                           const Text(
// //                             "Register",
// //                             style: TextStyle(
// //                                 fontSize: 28,
// //                                 fontWeight: FontWeight.bold,
// //                                 color: Appcolors.whitecolors),
// //                           ),
// //                           Row(
// //                             mainAxisAlignment: MainAxisAlignment.center,
// //                             children: [
// //                               const Text(
// //                                 "Already have an account? ",
// //                                 style: TextStyle(color: Appcolors.whitecolors),
// //                               ),
// //                               TextButton(
// //                                 onPressed: () {
// //                                   Navigator.pushReplacement(
// //                                       context,
// //                                       MaterialPageRoute(
// //                                           builder: (context) => LoginPage()));
// //                                 },
// //                                 child: const Text(
// //                                   "Login",
// //                                   style: TextStyle(color: Appcolors.bluecolors),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                           loginform(
// //                             controller: nameController,
// //                             label: "Company Name",
// //                             hintText: 'Enter Your Campany Name',
// //                           ),
// //                           loginform(
// //                             controller: emailController,
// //                             label: "Email",
// //                             hintText: 'Enter Your Email',
// //                           ),
// //                           loginform(
// //                             controller: addressController,
// //                             label: "Address",
// //                             hintText: 'Enter Your Address',
// //                           ),
// //                           loginform(
// //                             controller: phoneController,
// //                             label: "Phone Number",
// //                             hintText: 'Enter Your Phone Number',
// //                           ),
// //                           loginform(
// //                             controller: passwordController,
// //                             label: "Password",
// //                             hintText: 'Enter your Password',
// //                           ),
// //                           const SizedBox(height: 20),
// //                           SizedBox(
// //                             width: double.infinity,
// //                             height: 48,
// //                             child: ElevatedButton(
// //                               style: ElevatedButton.styleFrom(
// //                                 backgroundColor: Appcolors.trasparantcolos,
// //                                 shadowColor: Appcolors.trasparantcolos,
// //                                 foregroundColor: Appcolors.whitecolors,
// //                                 shape: RoundedRectangleBorder(
// //                                   borderRadius: BorderRadius.circular(12.0),
// //                                 ),
// //                               ),
// //                               onPressed: () {

// //                                 provider
// //                                     .registerUser(
// //                                   address: addressController.text,
// //                                   name: nameController.text,
// //                                   phone: phoneController.text,
// //                                   email: emailController.text.trim(),
// //                                   password: passwordController.text.trim(),
// //                                   context: context,
// //                                 )
// //                                     .then((value) {
// //                                   if (value != null) {
// //                                     final data = UserAcoountDb(
// //                                       email: emailController.text.trim(),
// //                                       password: passwordController.text.trim(),
// //                                     );
// //                                     addData(data);
// //                                     Navigator.pushReplacement(
// //                                       context,
// //                                       MaterialPageRoute(
// //                                         builder: (context) => const Homepage(),
// //                                       ),
// //                                     );
// //                                   }
// //                                 });
// //                               },
// //                               child: const Text("Register"),
// //                             ),
// //                           ),
// //                           const SizedBox(height: 20),
// //                         ],
// //                       );
// //                     },
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //...................
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shersoft/constants/colors.dart';
// import 'package:shersoft/view/login&register/login.dart';
// import 'package:video_player/video_player.dart';
// import 'package:shersoft/controller/login.dart';
// import 'package:shersoft/controller/localdb.dart';
// import 'package:shersoft/model/localdb.dart';
// import 'package:shersoft/view/home/homepage.dart';
// import 'package:shersoft/view/login&register/widget/widget.dart';

// class RegisterPage extends StatefulWidget {
//   const RegisterPage({super.key});

//   @override
//   State<RegisterPage> createState() => _RegisterPageState();
// }

// class _RegisterPageState extends State<RegisterPage> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController addressController = TextEditingController();

//   late VideoPlayerController _videoController;

//   @override
//   void initState() {
//     super.initState();
//     _videoController = VideoPlayerController.asset('asset/register.mp4')
//       ..initialize().then((_) {
//         _videoController.setLooping(true);
//         _videoController.setVolume(0.0);
//         _videoController.play();
//         setState(() {});
//       });
//   }

//   @override
//   void dispose() {
//     _videoController.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//     nameController.dispose();
//     phoneController.dispose();
//     addressController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard
//       child: Scaffold(
//         body: Stack(
//           children: [
//             _videoController.value.isInitialized
//                 ? SizedBox.expand(
//                     child: FittedBox(
//                       fit: BoxFit.cover,
//                       child: SizedBox(
//                         width: _videoController.value.size.width,
//                         height: _videoController.value.size.height,
//                         child: VideoPlayer(_videoController),
//                       ),
//                     ),
//                   )
//                 : Container(color: Colors.black),
//             Container(color: Colors.black.withOpacity(0.5)),
//             SingleChildScrollView(
//               child: Container(
//                 height: MediaQuery.of(context).size.height,
//                 padding: const EdgeInsets.all(20),
//                 child: Center(
//                   child: Container(
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     padding: const EdgeInsets.all(20),
//                     child: Consumer<UserController>(
//                       builder: (context, provider, child) {
//                         return Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             const SizedBox(height: 20),
//                             const Text(
//                               "Register",
//                               style: TextStyle(
//                                 fontSize: 28,
//                                 fontWeight: FontWeight.bold,
//                                 color: Appcolors.whitecolors,
//                               ),
//                             ),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Text(
//                                   "Already have an account? ",
//                                   style:
//                                       TextStyle(color: Appcolors.whitecolors),
//                                 ),
//                                 TextButton(
//                                   onPressed: () {
//                                     Navigator.pushReplacement(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               const LoginPage()),
//                                     );
//                                   },
//                                   child: const Text(
//                                     "Login",
//                                     style:
//                                         TextStyle(color: Appcolors.bluecolors),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             loginform(
//                               controller: nameController,
//                               label: "Company Name",
//                               hintText: 'Enter Your Company Name',
//                             ),
//                             loginform(
//                               controller: emailController,
//                               label: "Email",
//                               hintText: 'Enter Your Email',
//                             ),
//                             loginform(
//                               controller: addressController,
//                               label: "Address",
//                               hintText: 'Enter Your Address',
//                             ),
//                             loginform(
//                               controller: phoneController,
//                               label: "Phone Number",
//                               hintText: 'Enter Your Phone Number',
//                             ),
//                             loginform(
//                               controller: passwordController,
//                               label: "Password",
//                               hintText: 'Enter your Password',
//                             ),
//                             const SizedBox(height: 20),
//                             SizedBox(
//                               width: double.infinity,
//                               height: 48,
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Appcolors.trasparantcolos,
//                                   shadowColor: Appcolors.trasparantcolos,
//                                   foregroundColor: Appcolors.whitecolors,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12.0),
//                                   ),
//                                 ),
//                                 onPressed: () async {
//                                   if (emailController.text.isEmpty ||
//                                       passwordController.text.isEmpty ||
//                                       nameController.text.isEmpty ||
//                                       addressController.text.isEmpty ||
//                                       phoneController.text.isEmpty) {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content:
//                                             Text("Please fill all the fields"),
//                                         backgroundColor: Colors.red,
//                                       ),
//                                     );
//                                     return;
//                                   }

//                                   final result = await provider.registerUser(
//                                     address: addressController.text,
//                                     name: nameController.text,
//                                     phone: phoneController.text,
//                                     email: emailController.text.trim(),
//                                     password: passwordController.text.trim(),
//                                     context: context,
//                                   );

//                                   if (result == "register success" ||
//                                       result == "success") {
//                                     final data = UserAcoountDb(
//                                       email: emailController.text.trim(),
//                                       password: passwordController.text.trim(),
//                                     );
//                                     await addData(data); // Save locally

//                                     Navigator.pushReplacement(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) => const Homepage(),
//                                       ),
//                                     );
//                                   }
//                                 },
//                                 child: const Text("Register"),
//                               ),
//                             ),
//                             const SizedBox(height: 20),
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//...........
import 'package:budgetly/controller/localdb.dart';
import 'package:budgetly/controller/login.dart';
import 'package:budgetly/model/localdb.dart';
import 'package:budgetly/view/home/homepage.dart';
import 'package:budgetly/view/login&register/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF0008B4).withOpacity(0.8),
                  const Color(0xFF000490).withOpacity(0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF667eea),
                Color(0xFF764ba2),
                Color(0xFF0008B4),
              ],
              stops: [0.0, 0.5, 1.0],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 30),

                    // Animated Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.business,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Title
                    const Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                        shadows: [
                          Shadow(
                            blurRadius: 10,
                            color: Colors.black26,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Register your company",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Form Container
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Consumer<UserController>(
                        builder: (context, provider, child) {
                          return Column(
                            children: [
                              _buildTextField(
                                controller: nameController,
                                label: "Company Name",
                                hint: "Enter Your Company Name",
                                icon: Icons.business_center,
                              ),
                              _buildTextField(
                                controller: emailController,
                                label: "Email",
                                hint: "Enter Your Email",
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              _buildTextField(
                                controller: addressController,
                                label: "Address",
                                hint: "Enter Your Address",
                                icon: Icons.location_on_outlined,
                              ),
                              _buildTextField(
                                controller: phoneController,
                                label: "Phone Number",
                                hint: "Enter Your Phone Number",
                                icon: Icons.phone_outlined,
                                keyboardType: TextInputType.phone,
                              ),
                              _buildTextField(
                                controller: passwordController,
                                label: "Password",
                                hint: "Enter Your Password",
                                icon: Icons.lock_outline,
                                obscureText: true,
                              ),
                              const SizedBox(height: 24),

                              // Register Button
                              Container(
                                width: double.infinity,
                                height: 56,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF30CB76),
                                      Color(0xFF26A65B),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF30CB76)
                                          .withOpacity(0.4),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () async {
                                      if (emailController.text.isEmpty ||
                                          passwordController.text.isEmpty ||
                                          nameController.text.isEmpty ||
                                          addressController.text.isEmpty ||
                                          phoneController.text.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: const Text(
                                              "Please fill all the fields",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            backgroundColor:
                                                const Color(0xFFE53935),
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            margin: const EdgeInsets.all(20),
                                          ),
                                        );
                                        return;
                                      }

                                      final result =
                                          await provider.registerUser(
                                        address: addressController.text,
                                        name: nameController.text,
                                        phone: phoneController.text,
                                        email: emailController.text.trim(),
                                        password:
                                            passwordController.text.trim(),
                                        context: context,
                                      );

                                      if (result == "register success" ||
                                          result == "success") {
                                        final data = UserAcoountDb(
                                          email: emailController.text.trim(),
                                          password:
                                              passwordController.text.trim(),
                                        );
                                        await addData(data);

                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const Homepage(),
                                          ),
                                        );
                                      }
                                    },
                                    borderRadius: BorderRadius.circular(16),
                                    child: const Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.app_registration,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            "Register",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Login Link
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account?",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
