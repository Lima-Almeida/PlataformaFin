import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/widgets/drawer_menu.dart';

class Metas extends StatefulWidget {
  const Metas({super.key});

  @override
  State<Metas> createState() => _MetasState();
}

class _MetasState extends State<Metas> {
  final user = FirebaseAuth.instance.currentUser;
  Map<String, double> categoryBudgets = {};
  Map<String, double> categorySpendings = {};
  final Color green = Colors.greenAccent;
  final Color yellow = Colors.yellowAccent;
  final Color red = Colors.redAccent;

  @override
  void initState() {
    super.initState();
    loadCategoryData();
  }

  Future<void> loadCategoryData() async {
    final userId = user?.uid;

    if (userId != null) {
      final db = FirebaseFirestore.instance;
      final categoryCollection =
          db.collection('Usuários').doc(userId).collection('Categoria');

      // Fetch the categories
      final categorySnapshot = await categoryCollection.get();

      // Create a map to hold the budgets
      Map<String, double> budgets = {};

      // Loop through the categories
      for (var categoryDoc in categorySnapshot.docs) {
        final categoryName =
            categoryDoc['name']; // Assuming the field is 'name'

        // Fetch the years (Anos) for this category
        final yearCollection = categoryDoc.reference.collection('Anos');
        final yearSnapshot = await yearCollection.get();

        // Loop through the years
        for (var yearDoc in yearSnapshot.docs) {
          final year = yearDoc.id; // Assuming the document ID is the year

          // Fetch the months (Meses) for this year
          final monthCollection = yearDoc.reference.collection('Meses');
          final monthSnapshot = await monthCollection.get();

          // Loop through the months and get the 'limite' field
          for (var monthDoc in monthSnapshot.docs) {
            final limite =
                (monthDoc.data()['limite'] as num?)?.toDouble() ?? 0.0;

            if (limite > 0) {
              // Include only if limite > 0
              budgets['$categoryName - $year - ${monthDoc.id}'] = limite;
            }
          }
        }
      }

      // Calcular gastos por categoria
      final despesasSnapshot = await db
          .collection('Usuários')
          .doc(userId)
          .collection('Despesas')
          .get();

      Map<String, double> spendings = {};
      for (var doc in despesasSnapshot.docs) {
        final category = doc['categoria'];
        final value = (doc['valor'] as num?)?.toDouble() ?? 0.0;

        if (category != null) {
          spendings[category] = (spendings[category] ?? 0.0) + value;
        }
      }

      setState(() {
        print(spendings);
        categoryBudgets = budgets;
        categorySpendings = spendings;
      });
    }
  }

  Color getColor(double ratio) {
    if (ratio <= 0.3) {
      return green;
    } else if (ratio <= 0.7) {
      return yellow;
    } else {
      return red;
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text(
        'Metas por Categoria',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.blue,
    ),
    backgroundColor: Colors.grey[100],
    body: SafeArea(
      child: ListView(
        children: categoryBudgets.keys.map((categoryKey) {
          // Extract the category name before the first " - "
          final categoryName = categoryKey.split(' - ')[0];
          final budget = categoryBudgets[categoryKey] ?? 0.0;
          final spending = categorySpendings[categoryName] ?? 0.0;
          final ratio = budget > 0 ? (spending / budget) : 0.0;
          final progressBarColor = getColor(ratio);

          return Card(
            margin: const EdgeInsets.all(10.0),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoryKey,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GFProgressBar(
                    percentage: ratio.clamp(0.0, 1.0),
                    animation: true,
                    animateFromLastPercentage: true,
                    animationDuration: 400,
                    lineHeight: 25,
                    backgroundColor: const Color.fromARGB(255, 219, 219, 219),
                    progressBarColor: progressBarColor,
                    child: Text(
                      "${(ratio * 100).toStringAsFixed(1)}%",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Gastos: R\$${spending.toStringAsFixed(2)} / Meta: R\$${budget.toStringAsFixed(2)}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    ),
    drawer: DrawerMenu(),
  );
}

}
