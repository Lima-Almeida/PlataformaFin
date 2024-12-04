import 'package:flutter/material.dart';
import 'package:my_app/models/categoria.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/widgets/drawer_menu.dart';
import 'package:my_app/views/pages/cadastroReceitas.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddCategoryScreen extends StatefulWidget {
  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController limitController = TextEditingController();

  List<MonthlyLimit> monthlyLimits = [];
  int selectedYear = 2024; // Ano inicial selecionado
  List<int> yearsList = [2024, 2025, 2026, 2027, 2028, 2029, 2030]; // Lista de anos

  // Mapa para associar o número do mês ao nome do mês
  final Map<int, String> monthNames = {
    1: 'Janeiro',
    2: 'Fevereiro',
    3: 'Março',
    4: 'Abril',
    5: 'Maio',
    6: 'Junho',
    7: 'Julho',
    8: 'Agosto',
    9: 'Setembro',
    10: 'Outubro',
    11: 'Novembro',
    12: 'Dezembro',
  };

  // Função para carregar os limites do Firebase
  Future<void> loadMonthlyLimits() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final categoryCollection = FirebaseFirestore.instance
          .collection('Usuários')
          .doc(user.uid)
          .collection('Categoria');

      final categoryDocs = await categoryCollection.get();
      for (var doc in categoryDocs.docs) {
        final yearDoc = doc.reference.collection('Anos').doc(selectedYear.toString());
        final yearSnapshot = await yearDoc.get();
        
        if (yearSnapshot.exists) {
          final monthSnapshots = await yearDoc.collection('Meses').get();
          setState(() {
            monthlyLimits = monthSnapshots.docs.map((monthDoc) {
              return MonthlyLimit(
                month: int.parse(monthDoc.id),
                year: selectedYear,
                limit: monthDoc['limite'].toDouble(),
              );
            }).toList();
          });
        } else {
          // Se o ano não existe, criar um novo
          setState(() {
            monthlyLimits = List.generate(12, (index) {
              return MonthlyLimit(
                month: index + 1,
                year: selectedYear,
                limit: 0.0,
              );
            });
          });
        }
      }
    }
  }

  Future<void> addCategoryToFirebase(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final categoryCollection = FirebaseFirestore.instance
          .collection('Usuários')
          .doc(user.uid)
          .collection('Categoria');

      try {
        final categoryDoc = await categoryCollection.add({
          'name': nameController.text,
        });

        for (var limit in monthlyLimits) {
          final yearCollection = categoryDoc.collection('Anos').doc(limit.year.toString());
          await yearCollection.set({}); // Garantir que o documento do ano exista
          await yearCollection.collection('Meses').doc(limit.month.toString()).set({
            'limite': limit.limit,
          });
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Categoria e limites criados com sucesso!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CadastroReceitas()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao criar categoria ou limites.')),
        );
      }
    }
  }

  // Função para resetar o formulário
  void resetForm() {
    setState(() {
      selectedYear = 2024; // Ano inicial
      limitController.clear();
      monthlyLimits.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    loadMonthlyLimits(); // Carregar os limites do Firebase na inicialização
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Categoria'),
        backgroundColor: Colors.blue,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      backgroundColor: Colors.grey[100],
      drawer: DrawerMenu(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome da Categoria'),
              ),
              const SizedBox(height: 10),
              // Dropdown para selecionar o ano
              DropdownButton<int>(
                value: selectedYear,
                onChanged: (int? newYear) {
                  setState(() {
                    selectedYear = newYear!;
                    loadMonthlyLimits(); // Carregar os limites do novo ano
                  });
                },
                items: yearsList.map((int year) {
                  return DropdownMenuItem<int>(
                    value: year,
                    child: Text('$year'),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              // Exibe todos os meses do ano com os limites de forma mais limpa
              Expanded(
                child: ListView.builder(
                  itemCount: monthlyLimits.length,
                  itemBuilder: (context, index) {
                    final limit = monthlyLimits[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        title: Text(
                          '${monthNames[limit.month]}: R\$ ${limit.limit.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 18),
                        ),
                        onTap: () {
                          // Aqui você pode permitir editar o limite diretamente
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              final controller = TextEditingController(text: limit.limit.toString());
                              return AlertDialog(
                                title: const Text('Editar Limite'),
                                content: TextField(
                                  controller: controller,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(labelText: 'Novo Limite'),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        limit.limit = double.tryParse(controller.text) ?? limit.limit;
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Salvar'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: const Text('Cancelar'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => addCategoryToFirebase(context),
                child: const Text('Salvar Categoria'),
              ),
              TextButton(
                onPressed: resetForm,
                child: const Text('Reiniciar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
