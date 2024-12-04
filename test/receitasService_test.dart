import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:my_app/models/services/receitasService.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    receitasCollection = fakeFirestore.collection('Receitas');
    despesasCollection = fakeFirestore.collection('Despesas');
  });

  group('receitasService', () {
    test('getReceitasDespesas deve retornar lista de receitas e despesas', () async {
      await receitasCollection.add({
        'descricao': 'Salario',
        'valor': 2000.0,
        'categoria': 'Trabalho',
      });
      await despesasCollection.add({
        'descricao': 'Aluguel',
        'valor': 1000.0,
        'categoria': 'Habitacao',
      });

      final result = await getReceitasDespesas();

      expect(result.length, 2);
      expect(result[0]['descricao'], 'Salario');
      expect(result[1]['descricao'], 'Aluguel');
    });

    test('adicionarReceitaOuDespesa deve adicionar a receita', () async {
      await adicionarReceitaOuDespesa('Bonus', 500.0, 'Receita', 'Trabalho');
      final receitas = await receitasCollection.get();
      
      expect(receitas.docs.length, 1);
      expect(receitas.docs.first['descricao'], 'Bonus');
    });

    test('removerReceitaOuDespesa deve remover a receita ou despesa', () async {
      final docRef = await receitasCollection.add({
        'descricao': 'Freelance',
        'valor': 800.0,
        'categoria': 'Trabalho',
      });

      await removerReceitaOuDespesa(docRef.id, 'Receita');
      final receitas = await receitasCollection.get();

      expect(receitas.docs.length, 0);
    });
  });
}
