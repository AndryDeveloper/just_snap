import 'package:flutter/material.dart';
import 'UI/pages/history.dart';
import 'package:path_provider/path_provider.dart';
import 'globals.dart' as globals;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  globals.documentsPath = (await getApplicationDocumentsDirectory()).path;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Just Snap',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HistoryPage(),
    );
  }
}
