import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CadastroReceitas extends StatefulWidget {
  const CadastroReceitas({super.key});

  @override
  State<CadastroReceitas> createState() => CadastroReceitasState();
}

class CadastroReceitasState extends State<CadastroReceitas> {
  List<Map<String, dynamic>> receitasDespesas = [];

  final CollectionReference receitasCollection =
      FirebaseFirestore.instance.collection('Receitas');
  final CollectionReference despesasCollection =
      FirebaseFirestore.instance.collection('Despesas');

  @override
  void initState() {
    super.initState();
    getReceitasDespesas();
  }

  Future<void> getReceitasDespesas() async {
    List<Map<String, dynamic>> receitas = [];
    List<Map<String, dynamic>> despesas = [];

    QuerySnapshot receitasSnapshot = await receitasCollection.get();
    receitas = receitasSnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'descricao': doc['descricao'],
        'valor': doc['valor'],
        'categoria': doc['categoria'],
        'tipo': 'Receita',
      };
    }).toList();

    QuerySnapshot despesasSnapshot = await despesasCollection.get();
    despesas = despesasSnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'descricao': doc['descricao'],
        'valor': doc['valor'],
        'categoria': doc['categoria'],
        'tipo': 'Despesa',
      };
    }).toList();

    setState(() {
      receitasDespesas = [...receitas, ...despesas];
    });
  }

  Future<void> adicionarReceitaOuDespesa(
      String descricao, double valor, String tipo, String categoria) async {
    if (tipo == 'Receita') {
      await receitasCollection.add({
        'descricao': descricao,
        'valor': valor,
        'categoria': categoria,
      });
    } else if (tipo == 'Despesa') {
      await despesasCollection.add({
        'descricao': descricao,
        'valor': valor,
        'categoria': categoria,
      });
    }
    getReceitasDespesas();
  }

  Future<void> removerReceitaOuDespesa(String id, String tipo) async {
    if (tipo == 'Receita') {
      await receitasCollection.doc(id).delete();
    } else if (tipo == 'Despesa') {
      await despesasCollection.doc(id).delete();
    }

    getReceitasDespesas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receitas e Despesas'),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.grey[100],
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
                    //DataColumn(label: Text('Categoria')),
                    DataColumn(label: Text('Ações')),
                  ],
                  rows: receitasDespesas.map((item) {
                    return DataRow(
                      cells: [
                        DataCell(Text(item['descricao'])),
                        DataCell(Text(item['valor'].toString())),
                        DataCell(Text(item['tipo'],
                            style: TextStyle(
                              color: item['tipo'] == 'Receita'
                                  ? Colors.green
                                  : Colors.red,
                            ))),
                        //DataCell(Text(item['categoria'])),
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
                      items: const [
                        DropdownMenuItem(
                          value: 'Alimentacao',
                          child: Text('Alimentação'),
                        ),
                        DropdownMenuItem(
                          value: 'Transporte',
                          child: Text('Transporte'),
                        ),
                        DropdownMenuItem(
                          value: 'Entretenimento',
                          child: Text('Entretenimento'),
                        ),
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
                        adicionarReceitaOuDespesa(
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
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
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
                removerReceitaOuDespesa(id, tipo);
              },
            ),
          ],
        );
      },
    );
  }
}
