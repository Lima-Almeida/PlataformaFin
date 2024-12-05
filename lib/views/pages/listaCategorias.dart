import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_app/views/pages/cadastroCategoria.dart';
import 'package:my_app/widgets/drawer_menu.dart';

class ViewCategoriesScreen extends StatefulWidget {
  @override
  _ViewCategoriesScreenState createState() => _ViewCategoriesScreenState();
}

class _ViewCategoriesScreenState extends State<ViewCategoriesScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  int selectedYear = DateTime.now().year;
  int selectedMonth = DateTime.now().month;

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Categorias')),
        body: const Center(child: Text('Usuário não autenticado.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias'),
        backgroundColor: Colors.blue,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: DrawerMenu(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Ano de visualização:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
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
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Usuários')
                  .doc(user!.uid)
                  .collection('Categoria')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Erro ao carregar categorias.'));
                }

                final categories = snapshot.data?.docs ?? [];

                if (categories.isEmpty) {
                  return const Center(child: Text('Nenhuma categoria cadastrada.'));
                }

                return ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final categoryData = categories[index];
                    final categoryName = categoryData['name'] ?? 'Sem Nome';

                    return StreamBuilder<QuerySnapshot>(
                      stream: categoryData.reference
                          .collection('Anos')
                          .doc(selectedYear.toString())
                          .collection('Meses')
                          .snapshots(),
                      builder: (context, monthSnapshot) {
                        if (monthSnapshot.connectionState == ConnectionState.waiting) {
                          return ListTile(
                            title: Text(categoryName),
                            subtitle: const Text('Carregando limites...'),
                          );
                        }

                        final months = monthSnapshot.data?.docs ?? [];
                        final totalLimit = months.fold<double>(
                          0.0,
                          (sum, monthDoc) => sum + (monthDoc['limite'] ?? 0.0),
                        );

                        return ExpansionTile(
                          title: Text(
                            categoryName,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            months.isEmpty
                                ? 'Nenhum limite definido'
                                : 'Soma total dos limites: R\$ ${totalLimit.toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.add, color: Colors.green), // Botão de mais
                                onPressed: () => _addLimit(categoryData.id),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red), // Botão de excluir
                                onPressed: () async {
                                  // Lógica para excluir a categoria
                                  await _deleteCategory(categoryData.id);
                                },
                              ),
                            ],
                          ),
                          children: months.isEmpty
                              ? []
                              : months.map((monthDoc) {
                                  final month = int.parse(monthDoc.id);
                                  final limit = monthDoc['limite'] ?? 0.0;

                                  return ListTile(
                                    title: Text(
                                      _monthName(month),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    subtitle: Text(
                                      'Limite: R\$ ${limit.toStringAsFixed(2)}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () async {
                                        await _editLimit(
                                            categoryData.id, selectedYear, monthDoc.id, limit);
                                      },
                                    ),
                                  );
                                }).toList(),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddCategoryScreen()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
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

  Future<void> _editLimit(String categoryId, int year, String monthId, double currentLimit) async {
    final TextEditingController limitController = TextEditingController(text: currentLimit.toString());

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Limite'),
          content: TextField(
            controller: limitController,
            decoration: const InputDecoration(labelText: 'Limite (R\$)'),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final newLimit = double.tryParse(limitController.text) ?? 0.0;

                final limitRef = FirebaseFirestore.instance
                    .collection('Usuários')
                    .doc(user!.uid)
                    .collection('Categoria')
                    .doc(categoryId)
                    .collection('Anos')
                    .doc(year.toString())
                    .collection('Meses')
                    .doc(monthId);

                await limitRef.update({'limite': newLimit});
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Limite atualizado com sucesso!')),
                );
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addLimit(String categoryId) async {
    final TextEditingController limitController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar Limite'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<int>(
                value: selectedMonth,
                items: List.generate(12, (index) {
                  return DropdownMenuItem(
                    value: index + 1,
                    child: Text(_monthName(index + 1)),
                  );
                }).toList(),
                onChanged: (int? value) {
                  if (value != null) {
                    setState(() {
                      selectedMonth = value;
                    });
                  }
                },
              ),
              TextField(
                controller: limitController,
                decoration: const InputDecoration(labelText: 'Limite (R\$)'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final newLimit = double.tryParse(limitController.text) ?? 0.0;

                final limitRef = FirebaseFirestore.instance
                    .collection('Usuários')
                    .doc(user!.uid)
                    .collection('Categoria')
                    .doc(categoryId)
                    .collection('Anos')
                    .doc(selectedYear.toString())
                    .collection('Meses')
                    .doc(selectedMonth.toString());

                await limitRef.set({'limite': newLimit});
                setState(() {
                  // Força a atualização da visualização do mês selecionado
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Limite adicionado com sucesso!')),
                );
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteCategory(String categoryId) async {
    // Lógica para excluir categoria
    await FirebaseFirestore.instance
        .collection('Usuários')
        .doc(user!.uid)
        .collection('Categoria')
        .doc(categoryId)
        .delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Categoria excluída com sucesso!')),
    );
  }
}
