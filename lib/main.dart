
import 'package:flutter/material.dart';
import 'package:lesson_68/services/local_notifications_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotificationsService.start();

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      if (!LocalNotificationsService.notificationsEnabled) {
        await LocalNotificationsService.requestPermission();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!LocalNotificationsService.notificationsEnabled)
                  const Text(
                    "Siz xabarnomaga ruxsat bermadingiz shu sabab sizga xabarnomalar kelmaydi."
                        "\nBuni to'g'irlash uchun sozlamalarga borib to'girlang",
                  ),
                FilledButton(
                  onPressed: () {
                    LocalNotificationsService.showNotification();
                  },
                  child: const Text("Oddiy Xabarnoma"),
                ),
                FilledButton(
                  onPressed: () {
                    LocalNotificationsService.showScheduledNotification();
                  },
                  child: const Text("Rejali Xabarnoma"),
                ),
                FilledButton(
                  onPressed: () {
                    LocalNotificationsService.showPeriodicNotification();
                  },
                  child: const Text("Davomiy Xabarnoma"),
                ),
              ],
            ),
          )),
    );
  }
}
