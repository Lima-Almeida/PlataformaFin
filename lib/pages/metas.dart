import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';

class Metas extends StatefulWidget {
  const Metas({super.key});

  @override
  State<Metas> createState() => _MetasState();
}

class _MetasState extends State<Metas> {
  double budget = 100.0;
  double spending = 60.0;
  final TextEditingController dinheiroController = TextEditingController();

  Color getProgressColor(double ratio) {
    if (ratio <= 0.3) return Colors.greenAccent;
    if (ratio <= 0.7) return Colors.yellowAccent;
    return Colors.redAccent;
  }

  void updateBudget(String value) {
    try {
      final newBudget = double.parse(value);
      if (newBudget < 0) throw const SignalException("Budget menor que zero");

      setState(() {
        budget = newBudget;
      });
    } on SignalException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, digite um número positivo")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, digite um número válido")),
      );
    }
  }

  // Code smells de vazamento de memória
  @override
  void dispose() {
    dinheiroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentColor = getProgressColor(spending / budget);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metas e Orçamento'),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Despesas"),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "R\$${budget.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor: const Color.fromARGB(255, 0, 161, 22),
                            ),
                            onPressed: () {
                              dinheiroController.text = budget.toStringAsFixed(2);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Redefinir Meta de Orçamento"),
                                      content: TextFormField(
                                        controller: dinheiroController,
                                        decoration: const InputDecoration(labelText: 'Orçamento para o mês'),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: const Text('Cancelar'),
                                        ),
                                        FilledButton(
                                          onPressed: () {
                                            updateBudget(dinheiroController.text);
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Confirmar"),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            child: const Icon(
                              size: 20.0,
                              Icons.edit,
                              color: Color.fromARGB(255, 241, 241, 241),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GFProgressBar(
                      margin: const EdgeInsets.only(bottom: 5.0, left: 30.0, right: 30.0),
                      percentage: min(spending / budget, 1),
                      animation: true,
                      animateFromLastPercentage: true,
                      animationDuration: 400,
                      lineHeight: 25,
                      padding: const EdgeInsets.only(right: 5),
                      backgroundColor: const Color.fromARGB(255, 219, 219, 219),
                      progressBarColor: currentColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${(spending / budget * 100).toStringAsFixed(1)}%",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Text("R\$${spending.toStringAsFixed(2)} out of R\$${budget.toStringAsFixed(2)}"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
