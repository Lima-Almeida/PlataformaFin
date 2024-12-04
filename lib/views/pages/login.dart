import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_app/models/services/loginService.dart';
import 'package:my_app/views/components/TextInput.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback showRegisterPage;
  const LoginScreen({super.key, required this.showRegisterPage});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

void _validateAndSignIn() async {
  final email = _emailController.text.trim();
  final password = _passwordController.text.trim();

  if (email.isEmpty || !email.contains('@') || email.length > 254) {
    if (mounted) {
      setState(() {
        _errorMessage = "Por favor, insira um endereço de email válido.";
      });
    }
    return;
  }

  if (password.isEmpty || password.length < 6 || password.length > 128) {
    if (mounted) {
      setState(() {
        _errorMessage = "A senha deve ter entre 6 e 128 caracteres.";
      });
    }
    return;
  }

  final result = await LoginService.signIn(email, password);

  if (mounted) {
    setState(() {
      _errorMessage = result;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.monetization_on,
                  size: 100,
                  color: Colors.blue,
                ),
                Text('Plataforma Financeiro',
                    style: GoogleFonts.bebasNeue(
                        fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(height: 50),
                if (_errorMessage != null) ...[
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                ],
                TextInput(placeholder: "Email", controller: _emailController),
                const SizedBox(height: 10),
                TextInput(
                    placeholder: "Password",
                    obscureText: true,
                    controller: _passwordController),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: GestureDetector(
                    onTap: _validateAndSignIn,
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          "Entrar",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Ainda não possui uma conta?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: widget.showRegisterPage,
                  child: const Text(
                    'Cadastre-se',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
