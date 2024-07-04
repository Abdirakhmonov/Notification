import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lesson_68/services/local_notification_service.dart';
import 'package:lesson_68/views/screens/home_page.dart';

import 'firebase_options.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationsService.requestPermission();
  await LocalNotificationsService.start();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainRunner());
}

class MainRunner extends StatelessWidget {
  const MainRunner({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false, home: Homepage());
  }
}
