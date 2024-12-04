import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/services/logout.dart';
import 'package:my_app/models/services/receitasService.dart';
import 'package:my_app/views/pages/cadastroCategoria.dart';
import 'package:my_app/views/pages/login.dart';
import 'package:my_app/views/pages/metas.dart';
import 'package:my_app/widgets/drawer_menu.dart';

class CadastroReceitas extends StatefulWidget {
  const CadastroReceitas({super.key});

  @override
  State<CadastroReceitas> createState() => CadastroReceitasState();
}

class CadastroReceitasState extends State<CadastroReceitas> {
  final user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> receitasDespesas = [];
  List<String> categoriasUsuario = [];
  List<String> categoriasPredefinidas = [
    'Alimentação', 'Transporte', 'Entretenimento'
  ];
  String? categoriaSelecionada;

  @override
  void initState() {
    super.initState();
    loadReceitasDespesas();
    loadCategoriasUsuario();
  }

  // Função para carregar as categorias criadas pelo usuário
  void loadCategoriasUsuario() async {
    final userId = user?.uid;
    if (userId != null) {
      final categoryCollection = FirebaseFirestore.instance
          .collection('Usuários')
          .doc(userId)
          .collection('Categoria');

      // Carregar as categorias do usuário
      final snapshot = await categoryCollection.get();
      List<String> categorias = [];
      for (var doc in snapshot.docs) {
        categorias.add(doc['name']);
      }

      setState(() {
        categoriasUsuario = categorias;
      });
    }
  }

  void loadReceitasDespesas() async {
    final userId = user?.uid;
    if (userId != null) {
      final db = FirebaseFirestore.instance;

      final receitasSnapshot = await db.collection('Usuários').doc(userId).collection('Receitas').get();
      final despesasSnapshot = await db.collection('Usuários').doc(userId).collection('Despesas').get();

      List<Map<String, dynamic>> updatedList = [];
      
      // Carregar receitas
      for (var doc in receitasSnapshot.docs) {
        updatedList.add({
          'id': doc.id,
          'descricao': doc['descricao'],
          'valor': doc['valor'],
          'tipo': 'Receita',
          'categoria': doc['categoria'],
        });
      }

      // Carregar despesas
      for (var doc in despesasSnapshot.docs) {
        updatedList.add({
          'id': doc.id,
          'descricao': doc['descricao'],
          'valor': doc['valor'],
          'tipo': 'Despesa',
          'categoria': doc['categoria'],
        });
      }

      setState(() {
        receitasDespesas = updatedList;
      });
    }
  }

  void adicionarRecOuDes(String descricao, double valor, String tipo, String categoria) async {
    final userId = user?.uid;

    if (userId != null) {
      final db = FirebaseFirestore.instance;

      final ref = db.collection('Usuários').doc(userId);

      if (tipo == 'Receita') {
        await ref.collection('Receitas').add({
          'descricao': descricao,
          'valor': valor,
          'categoria': categoria,
          'tipo': tipo,
          'dataCriacao': FieldValue.serverTimestamp(),
        });
      } else if (tipo == 'Despesa') {
        await ref.collection('Despesas').add({
          'descricao': descricao,
          'valor': valor,
          'categoria': categoria,
          'tipo': tipo,
          'dataCriacao': FieldValue.serverTimestamp(),
        });
      }

      loadReceitasDespesas();
    }
  }

  void removerRecOuDes(String id, String tipo) async {
    final userId = user?.uid;
    if (userId != null) {
      final db = FirebaseFirestore.instance;

      if (tipo == 'Receita') {
        await db.collection('Usuários').doc(userId).collection('Receitas').doc(id).delete();
      } else if (tipo == 'Despesa') {
        await db.collection('Usuários').doc(userId).collection('Despesas').doc(id).delete();
      }

      loadReceitasDespesas();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receitas e Despesas'),
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Descrição')),
                    DataColumn(label: Text('Valor')),
                    DataColumn(label: Text('Tipo')),
                    DataColumn(label: Text('Ações')),
                  ],
                  rows: receitasDespesas.map((item) {
                    return DataRow(
                      cells: [
                        DataCell(Text(item['descricao'])),
                        DataCell(Text(item['valor'].toString())),
                        DataCell(Text(item['tipo'],
                            style: TextStyle(
                              color: item['tipo'] == 'Receita' ? Colors.green : Colors.red,
                            ))),
                        DataCell(
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              mostrarDialogoRemocao(item['id'], item['tipo']);
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              final descricaoController = TextEditingController();
              final valorController = TextEditingController();
              String? tipoSelecionado;
              String? categoria;

              return AlertDialog(
                title: const Text('Adicionar Receita/Despesa'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: descricaoController,
                      decoration: const InputDecoration(labelText: 'Descrição'),
                    ),
                    TextField(
                      controller: valorController,
                      decoration: const InputDecoration(labelText: 'Valor'),
                      keyboardType: TextInputType.number,
                    ),
                    DropdownButtonFormField<String>(
                      value: tipoSelecionado,
                      items: const [
                        DropdownMenuItem(
                          value: 'Receita',
                          child: Text('Receita'),
                        ),
                        DropdownMenuItem(
                          value: 'Despesa',
                          child: Text('Despesa'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          tipoSelecionado = value;
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Tipo'),
                    ),
                    DropdownButtonFormField<String>(
                      value: categoria,
                      items: [
                        ...categoriasPredefinidas.map((cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(cat),
                            )),
                        ...categoriasUsuario.map((cat) => DropdownMenuItem(
                              value: cat,
                              child: Text(cat),
                            )),
                      ],
                      onChanged: (value) {
                        setState(() {
                          categoria = value;
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Categoria'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (descricaoController.text.isNotEmpty &&
                          valorController.text.isNotEmpty &&
                          tipoSelecionado != null &&
                          categoria != null) {
                        adicionarRecOuDes(
                            descricaoController.text,
                            double.parse(valorController.text),
                            tipoSelecionado!,
                            categoria!);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Adicionar'),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }

  void mostrarDialogoRemocao(String id, String tipo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmação"),
          content: const Text("Deseja remover este item?"),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text("Remover"),
              onPressed: () {
                Navigator.of(context).pop();
                removerRecOuDes(id, tipo);
              },
            ),
          ],
        );
      },
    );
  }
}
