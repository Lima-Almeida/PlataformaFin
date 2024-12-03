import 'package:flutter/material.dart';
import 'package:my_app/models/categoria.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_app/widgets/drawer_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewCategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

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
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Usuários')
            .doc(user.uid)
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
                stream: FirebaseFirestore.instance
                    .collection('Usuários')
                    .doc(user.uid)
                    .collection('Categoria')
                    .doc(categoryData.id)
                    .collection('Anos')
                    .snapshots(),
                builder: (context, yearSnapshot) {
                  if (yearSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(
                      title: Text(categoryName),
                      subtitle: const Text('Carregando...'),
                    );
                  }

                  final years = yearSnapshot.data?.docs ?? [];

                  return ExpansionTile(
                    title: Text(categoryName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    children: years.map((yearDoc) {
                      final year = int.parse(yearDoc.id);

                      return StreamBuilder<QuerySnapshot>(
                        stream: yearDoc.reference.collection('Meses').snapshots(),
                        builder: (context, monthSnapshot) {
                          if (monthSnapshot.connectionState == ConnectionState.waiting) {
                            return const ListTile(title: Text('Carregando meses...'));
                          }

                          final months = monthSnapshot.data?.docs ?? [];

                          return Column(
                            children: months.map((monthDoc) {
                              final month = int.parse(monthDoc.id);
                              final limit = monthDoc['limite'] ?? 0.0;

                              return ListTile(
                                title: Text(
                                  _monthName(month),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                subtitle: Text(
                                  'Limite: R\$ ${limit.toStringAsFixed(2)}\n',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      );
                    }).toList(),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String _monthName(int month) {
    const monthNames = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return monthNames[month - 1];
  }
}
