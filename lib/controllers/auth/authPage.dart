import 'package:flutter/material.dart';
import 'package:my_app/views/pages/cadastro.dart';
import 'package:my_app/views/pages/login.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  
  bool showLogInPage = true;

  void toggleScreens() {
    setState(() {
      showLogInPage = !showLogInPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLogInPage) {
      return LoginScreen(showRegisterPage: toggleScreens);
    } else {
      return CadastroScreen(showLoginPage: toggleScreens);
    }
  }
}