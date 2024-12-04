import 'package:firebase_auth/firebase_auth.dart';

class LoginService {
  static Future<String?> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException {
      return "Credencial de autenticação inválida.";
    } catch (e) {
      return "Erro inesperado: $e";
    }
  }
}
