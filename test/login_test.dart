import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';

class MockFirebaseAuthWithCustomErrors extends MockFirebaseAuth {
  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {

    if (email.isEmpty || !email.contains('@') || email.length > 254) {
      throw Exception('Invalid email address.');
    }

    if (password.isEmpty || password.length < 6 || password.length > 128) {
      throw Exception('Invalid password.');
    }
    return super.signInWithEmailAndPassword(email: email, password: password);
  }
}

void main() {
  group('Login', () {
    late MockFirebaseAuthWithCustomErrors mockAuth;
    late TextEditingController emailController;
    late TextEditingController passwordController;

    setUp(() {
      mockAuth = MockFirebaseAuthWithCustomErrors();
      emailController = TextEditingController();
      passwordController = TextEditingController();
    });

    tearDown(() {
      emailController.dispose();
      passwordController.dispose();
    });

    test('Login falha com email vazio (Analise de Valor Limite)', () async {
      emailController.text = '';
      passwordController.text = 'senha123';

      expect(
        () async => await mockAuth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid email address.'),
          ),
        ),
      );
    });

    test('Login falha com email muito longo (Analise de Valor Limite)', () async {
      emailController.text = '${'a' * 255}@test.com';
      passwordController.text = 'password123';

      expect(
        () async => await mockAuth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid email address.'),
          ),
        ),
      );
    });

    test('Login falha com senha vazia (Analise de Valor Limite)', () async {
      emailController.text = 'test@test.com';
      passwordController.text = '';

      expect(
        () async => await mockAuth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid password.'),
          ),
        ),
      );
    });

    test('Login falha com senha com menos de 6 caracteres (Analise de Valor Limite)', () async {
      emailController.text = 'test@test.com';
      passwordController.text = '12345';

      expect(
        () async => await mockAuth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid password.'),
          ),
        ),
      );
    });

    test('Login falha com senha com mais de 128 caracteres (Analise de Valor Limite)', () async {
      emailController.text = 'test@test.com';
      passwordController.text = 'a' * 129;

      expect(
        () async => await mockAuth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid password.'),
          ),
        ),
      );
    });

    test('Sucesso no login com email e senhas validos', () async {
      emailController.text = 'test@test.com';
      passwordController.text = 'senha123';

      await mockAuth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      await mockAuth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = mockAuth.currentUser;
      expect(user, isNotNull);
      expect(user?.email, equals('test@test.com'));
    });
  });
}
