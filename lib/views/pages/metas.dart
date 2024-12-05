import 'package:my_app/widgets/drawer_menu.dart'; // Importando o DrawerMenu
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExpensesChartScreen extends StatefulWidget {
  @override
  _ExpensesChartScreenState createState() => _ExpensesChartScreenState();
}

class _ExpensesChartScreenState extends State<ExpensesChartScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;
  double totalLimit = 0.0;
  double totalExpenses = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchTotalLimit();
    _fetchTotalExpenses();
  }

  void _fetchTotalLimit() async {
    if (user == null) return;

    final categoriesSnapshot = await FirebaseFirestore.instance
        .collection('Usuários')
        .doc(user!.uid)
        .collection('Categoria')
        .get();

    double limitSum = 0.0;

    for (var category in categoriesSnapshot.docs) {
      final monthsSnapshot = await category.reference
          .collection('Anos')
          .doc(selectedYear.toString())
          .collection('Meses')
          .doc(selectedMonth.toString())
          .get();

      if (monthsSnapshot.exists) {
        final limit = monthsSnapshot['limite'] ?? 0.0;
        limitSum += limit;
      }
    }

    setState(() {
      totalLimit = limitSum;
    });
  }

  void _fetchTotalExpenses() async {
    if (user == null) return;

    final categoriesSnapshot = await FirebaseFirestore.instance
        .collection('Usuários')
        .doc(user!.uid)
        .collection('Categoria')
        .get();

    double expensesSum = 0.0;

    for (var category in categoriesSnapshot.docs) {
      final monthsSnapshot = await category.reference
          .collection('Anos')
          .doc(selectedYear.toString())
          .collection('Meses')
          .doc(selectedMonth.toString())
          .get();

      if (monthsSnapshot.exists) {
        final expenses = monthsSnapshot['despesas'] ?? 0.0; // Supondo que 'despesas' seja o campo das despesas
        expensesSum += expenses;
      }
    }

    setState(() {
      totalExpenses = expensesSum;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gráfico de Despesas'),
        backgroundColor: Colors.blue,
      ),
      drawer: DrawerMenu(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<int>(
                  value: selectedYear,
                  items: List.generate(
                    10,
                    (index) => DateTime.now().year - 5 + index,
                  ).map((year) {
                    return DropdownMenuItem(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedYear = value;
                        _fetchTotalLimit();
                        _fetchTotalExpenses();
                      });
                    }
                  },
                ),
                DropdownButton<int>(
                  value: selectedMonth,
                  items: List.generate(12, (index) => index + 1).map((month) {
                    return DropdownMenuItem(
                      value: month,
                      child: Text(_monthName(month)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedMonth = value;
                        _fetchTotalLimit();
                        _fetchTotalExpenses();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Limite Total: R\$ ${totalLimit.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'Despesas Totais: R\$ ${totalExpenses.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: _buildBarChart(),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    double progress = totalLimit > 0 ? totalExpenses / totalLimit : 0.0;

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Progresso das Despesas no Limite Mensal',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  height: 30,
                  width: progress * MediaQuery.of(context).size.width,
                  color: Colors.green,
                ),
                Container(
                  height: 30,
                  width: (1 - progress) * MediaQuery.of(context).size.width,
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String _monthName(int month) {
  const monthNames = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro'
  ];
  return monthNames[month - 1];
}
