import 'package:flutter/material.dart';
import 'package:getwidget/components/progress_bar/gf_progress_bar.dart';
import 'package:my_app/models/services/logout.dart';
import 'package:my_app/views/pages/cadastroCategoria.dart';
import '../components/constants.dart';  // Importando o arquivo de constantes para cores
import 'package:my_app/views/pages/cadastroReceitas.dart';
import 'package:my_app/views/pages/cadastro.dart';
import 'package:my_app/widgets/drawer_menu.dart'; // Importando o DrawerMenu


class Metas extends StatefulWidget {
  const Metas({super.key});

  @override
  State<Metas> createState() => _MetasState();
}

class _MetasState extends State<Metas> {
  double budget = 0.0;
  double spending = 0.0;
  final Color green = Colors.greenAccent;
  final Color yellow = Colors.yellowAccent;
  final Color red = Colors.redAccent;
  Color currentColor = Colors.grey;

  @override
  void initState() {
    super.initState();
    getBudgetAndSpendings();
    setCurrentColor();
  }

  void setCurrentColor() {
    double ratio = spending / budget;
    setState(() {
      if (ratio <= 0.3) {
        currentColor = green;
      } else if (ratio <= 0.7) {
        currentColor = yellow;
      } else {
        currentColor = red;
      }
    });
  }

  Future<void> getBudgetAndSpendings() async {
    setState(() {
      budget = 100.0;
      spending = 60.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Metas e Orçamento',
          style: TextStyle(
            color: Colors.white, // Cor branca para o texto
            fontWeight: FontWeight.bold, // Tornar o texto em negrito
          ),
        ),
        backgroundColor: AppColors.primaryColor,
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
                              final dinheiroController = TextEditingController(text: budget.toStringAsFixed(2));

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
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancelar'),
                                        ),
                                        FilledButton(
                                          onPressed: () {
                                            if (dinheiroController.text.isNotEmpty) {
                                              try {
                                                double newBudget = double.parse(dinheiroController.text);
                                                setState(() {
                                                  budget = newBudget;
                                                });
                                                setCurrentColor();
                                                Navigator.pop(context);
                                              } catch (parseError) {
                                                final scaffold = ScaffoldMessenger.of(context);
                                                scaffold.showSnackBar(
                                                  const SnackBar(content: Text("Por favor, digite um número")),
                                                );
                                              }
                                            }
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
                      percentage: spending / budget,
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
                    Text("R\$${spending.toStringAsFixed(2)} out of R\$${budget.toStringAsFixed((2))}"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: DrawerMenu(),
    );
  }
}
