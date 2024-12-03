import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../components/constants.dart';  // Importando o arquivo de constantes para cores

class CadastroScreen extends StatefulWidget {
  final VoidCallback showLoginPage;
  const CadastroScreen({super.key, required this.showLoginPage});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  final CollectionReference usuariosCollection =
      FirebaseFirestore.instance.collection('Usuários');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _registrar() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Criar o usuário com email e senha
        UserCredential userCredential = await _registrarUsuario();

        // Adicionar o nome do usuário ao Firestore
        await _salvarUsuarioFirestore(userCredential.user!.uid);

        // Mostrar mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário registrado com sucesso!')),
        );

        // Limpar os campos após o registro
        _formKey.currentState!.reset();
        _nomeController.clear();
        _emailController.clear();
        _senhaController.clear();
      } catch (e) {
        // Tratar erros de registro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: ${e.toString()}')),
        );
      }
    }
  }

  Future<UserCredential> _registrarUsuario() async {
    String email = _emailController.text;
    String senha = _senhaController.text;
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: senha,
    );
  }

  Future<void> _salvarUsuarioFirestore(String uid) async {
    String nome = _nomeController.text;
    String email = _emailController.text;
    await usuariosCollection.doc(uid).set({
      'nome': nome,
      'email': email,
    });
  }

  String? _validarEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu email';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Insira um email válido';
    }
    return null;
  }

  String? _validarSenha(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira sua senha';
    }
    if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    if (value.length > 128) {
      return 'A senha deve ter no máximo 128 caracteres';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cadastro de Usuário',
          style: TextStyle(
            color: AppColors.textSecondaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Crie sua conta',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    key: const Key('nomeField'),
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira seu nome';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key('emailField'),
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    validator: _validarEmail,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    key: const Key('senhaField'),
                    controller: _senhaController,
                    decoration: const InputDecoration(
                      labelText: 'Senha',
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    obscureText: true,
                    validator: _validarSenha,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _registrar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text(
                      'Registrar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('Já tem uma conta?'),
                  GestureDetector(
                    onTap: widget.showLoginPage,
                    child: const Text(
                        'Faça login',
                        style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
