import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';

class MockFirebaseAuthWithCustomErrors extends MockFirebaseAuth {
  @override
  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || !email.contains('@') || email.length > 254 || email.contains('!')
        || email.contains('#') || email.contains('%') || email.contains('&') || email.contains('*')
        || email.contains('(') || email.contains(')') || email.contains('-') || email.contains('+')
        || email.contains('=') || email.contains('[') || email.contains(']') || email.contains('{')
        || email.contains('}') || email.contains('/') || email.contains('\\') || email.contains('|')
        || email.contains(';') || email.contains(':') || email.contains(',') || email.contains('<')
        || email.contains('>') || email.contains('?') || email.contains('`') || email.contains('~')
        || email.contains(' ') || email.contains('\'') || email.contains('"') || email.contains('´')
        || email.contains('^') || email.contains('¨') || email.contains('§') || email.contains('ª')
        || email.contains('º') || email.contains('°')) {
      throw Exception('Invalid email address.');
    }
    if (password.isEmpty || password.length < 6 || password.length > 128) {
      throw Exception('Invalid password.');
    }
    return super.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}

class MockFirestore extends Mock implements FirebaseFirestore {}

void main() {
  group('Cadastro', () {
    late MockFirebaseAuthWithCustomErrors mockAuth;
    late MockFirestore mockFirestore;
    late TextEditingController nomeController;
    late TextEditingController emailController;
    late TextEditingController senhaController;

    setUp(() {
      mockAuth = MockFirebaseAuthWithCustomErrors();
      mockFirestore = MockFirestore();
      nomeController = TextEditingController();
      emailController = TextEditingController();
      senhaController = TextEditingController();
    });

    tearDown(() {
      nomeController.dispose();
      emailController.dispose();
      senhaController.dispose();
    });

    test('Cadastro falha com nome vazio', () async {
      nomeController.text = '';
      emailController.text = 'test@test.com';
      senhaController.text = 'senha123';

      expect(
        () async {
          if (nomeController.text.isEmpty) {
            throw Exception('Invalid name.');
          }
          await mockAuth.createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: senhaController.text.trim(),
          );
        },
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid name.'),
          ),
        ),
      );
    });

    test('Cadastro falha com email inválido', () async {
      nomeController.text = 'Test User';
      emailController.text = 'invalid-email';
      senhaController.text = 'senha123';

      expect(
        () async => await mockAuth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: senhaController.text.trim(),
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

    //Classes de equivalência:
    // [0-6] -> Inválido
    // [6-128] -> Válido
    // [128-∞] -> Inválido
    test(
        'Cadastro falha com senha menor que 6 caracteres (Classes de Equivalência)',
        () async {
      nomeController.text = 'Test User';
      emailController.text = 'test@test.com';
      senhaController.text = '123';

      expect(
        () async => await mockAuth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: senhaController.text.trim(),
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

    test(
        'Cadastro falha com senha maior que 128 caracteres (Classes de Equivalência)',
        () async {
      nomeController.text = 'Test User';
      emailController.text = 'test@test.com';
      senhaController.text = 'a' * 200;

      expect(
        () async => await mockAuth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: senhaController.text.trim(),
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

//Classes de Equivalência: 
//[0-254] -> Válido
//[254-∞] -> Inválido
//com @ -> Válido
//sem @ -> Inválido
//com caracteres inválidos -> Inválido
    test('Cadastro falha com email sem o caractere @ (Classes de Equivalência)',
        () async {
      nomeController.text = 'Test User';
      emailController.text = 'usuarioemail.com';
      senhaController.text = 'senha123';

      expect(
        () async => await mockAuth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: senhaController.text.trim(),
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

    test(
        'Cadastro falha com email contendo caracteres inválidos (Classes de Equivalência)',
        () async {
      nomeController.text = 'Test User';
      emailController.text = 'usuario@domínio!.com';
      senhaController.text = 'senha123';

      expect(
        () async => await mockAuth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: senhaController.text.trim(),
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

    test('Cadastro falha com email vazio (Classes de Equivalência)', () async {
      nomeController.text = 'Test User';
      emailController.text = '';
      senhaController.text = 'senha123';

      expect(
        () async => await mockAuth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: senhaController.text.trim(),
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

    test(
        'Cadastro falha com email maior que 254 caracteres (Classes de Equivalência)',
        () async {
      nomeController.text = 'Test User';
      emailController.text = '${'a' * 245}@example.com';
      senhaController.text = 'senha123';

      expect(
        () async => await mockAuth.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: senhaController.text.trim(),
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

    test('Cadastro com sucesso com email válido (Classes de Equivalência)',
        () async {
      nomeController.text = 'Test User';
      emailController.text = 'usuario@dominio.com';
      senhaController.text = 'senha123';

      final userCredential = await mockAuth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: senhaController.text.trim(),
      );

      expect(userCredential.user, isNotNull);
      expect(userCredential.user?.email, equals('usuario@dominio.com'));
    });
  });
}
