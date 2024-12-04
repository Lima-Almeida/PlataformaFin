import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_app/firebase_options.dart';
<<<<<<< HEAD
import 'package:my_app/pages/cadastro.dart';
=======
import 'package:my_app/controllers/auth/mainPage.dart';
import 'package:my_app/views/pages/cadastroCategoria.dart';
>>>>>>> b4eef3107cdb6e3ec843c349cd126563f4efbf92

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
