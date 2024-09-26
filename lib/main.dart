import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:gui_nim/gui_nim.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(routes: <String, WidgetBuilder>{
      '/LoserPage': (BuildContext context) => const LoserPage(),
      '/WinnerPage': (BuildContext context) => const WinnerPage(),
    }, home: const GuiNim());
  }
}
