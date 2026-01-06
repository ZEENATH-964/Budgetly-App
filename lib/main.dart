import 'dart:developer';
import 'package:budgetly/backup/backup.dart';
import 'package:budgetly/controller/dataController.dart';
import 'package:budgetly/controller/login.dart';
import 'package:budgetly/controller/them.dart';
import 'package:budgetly/firebase_options.dart';
import 'package:budgetly/model/import_transactiondb.dart';
import 'package:budgetly/model/localdb.dart';
import 'package:budgetly/view/splash.dart';
import 'package:budgetly/view/totelscreentime/screentime.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AppUsageTracker().init();

  await Hive.initFlutter();
  Hive.registerAdapter(UserAcoountDbAdapter());
  await Hive.openBox<UserAcoountDb>('user-db');
  Hive.registerAdapter(ImportTransactiondbAdapter());
  await Hive.openBox<ImportTransactiondb>('import_transactions');



  FirebaseMessaging.instance.onTokenRefresh.listen(updateFcmToken);
  runApp(const MyApp());
}

Future<void> updateFcmToken(String newToken) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(user.uid)
        .update({'fcmToken': newToken});
    log("🔄 Token updated: $newToken");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserController()),
        ChangeNotifierProvider(create: (_) => Datacontroller()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => SyncController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
        home: SplashScreen(),
      ),
    );
  }
}
