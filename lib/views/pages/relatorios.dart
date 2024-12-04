import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/widgets/drawer_menu.dart';

class Relatorios extends StatefulWidget {
  const Relatorios({super.key});

  @override
  State<Relatorios> createState() => _RelatoriosState();
}

class _RelatoriosState extends State<Relatorios> {
  final user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> receitasDespesas = [];
  double totalReceitas = 0.0;
  double totalDespesas = 0.0;

  @override
  void initState() {
    super.initState();
    loadReceitasDespesas();
  }

  void loadReceitasDespesas() async {
    final userId = user?.uid;
    if (userId != null) {
      final db = FirebaseFirestore.instance;

      final receitasSnapshot =
          await db.collection('Usuários').doc(userId).collection('Receitas').get();
      final despesasSnapshot =
          await db.collection('Usuários').doc(userId).collection('Despesas').get();

      List<Map<String, dynamic>> updatedList = [];

      double receitas = 0.0;
      double despesas = 0.0;

      // Carregar receitas
      for (var doc in receitasSnapshot.docs) {
        double valor = (doc['valor'] as num).toDouble();
        receitas += valor;
        updatedList.add({
          'id': doc.id,
          'descricao': doc['descricao'],
          'valor': valor,
          'tipo': 'Receita',
          'categoria': doc['categoria'],
        });
      }

      // Carregar despesas
      for (var doc in despesasSnapshot.docs) {
        double valor = (doc['valor'] as num).toDouble();
        despesas += valor;
        updatedList.add({
          'id': doc.id,
          'descricao': doc['descricao'],
          'valor': valor,
          'tipo': 'Despesa',
          'categoria': doc['categoria'],
        });
      }

      setState(() {
        receitasDespesas = updatedList;
        totalReceitas = receitas;
        totalDespesas = despesas;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double saldoAtual = totalReceitas - totalDespesas;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Relatórios Financeiros',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue,
      ),
      drawer: DrawerMenu(),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tabela de receitas, despesas e saldo
              Card(
                child: ListTile(
                  title: const Text(
                    'Receitas Totais',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  trailing: Text(
                    'R\$ ${totalReceitas.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: ListTile(
                  title: const Text(
                    'Despesas Totais',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  trailing: Text(
                    'R\$ ${totalDespesas.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Card(
                child: ListTile(
                  title: const Text(
                    'Saldo Atual',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  trailing: Text(
                    'R\$ ${saldoAtual.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: saldoAtual >= 0 ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Tabela detalhada de receitas e despesas
              const Text(
                'Detalhes de Receitas e Despesas',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Descrição')),
                      DataColumn(label: Text('Valor')),
                      DataColumn(label: Text('Tipo')),
                      DataColumn(label: Text('Categoria')),
                    ],
                    rows: receitasDespesas.map((item) {
                      return DataRow(
                        cells: [
                          DataCell(Text(item['descricao'])),
                          DataCell(Text('R\$ ${item['valor'].toStringAsFixed(2)}')),
                          DataCell(Text(
                            item['tipo'],
                            style: TextStyle(
                              color: item['tipo'] == 'Receita'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          )),
                          DataCell(Text(item['categoria'] ?? 'N/A')),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
