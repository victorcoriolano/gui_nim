import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:gui_nim/view-model/gui_nim.dart';
import 'package:gui_nim/view/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(routes: <String, WidgetBuilder>{
      '/LoserPage': (BuildContext context) => const LoserPage(),
      '/WinnerPage': (BuildContext context) => const WinnerPage(
            nickname: 'Jogador',
          ),
      '/GameSettingsPage': (BuildContext context) => const GameSettingsPage(),
    }, debugShowCheckedModeBanner: false, home: const GameSettingsPage());
  }
}
