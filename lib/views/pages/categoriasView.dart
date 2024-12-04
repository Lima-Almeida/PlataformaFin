import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/categoria.dart';


class CategoryDetailsScreen extends StatelessWidget {
  final Category category;

  CategoryDetailsScreen({required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: ListView.builder(
        itemCount: category.monthlyLimits.length,
        itemBuilder: (context, index) {
          final limit = category.monthlyLimits[index];
          return ListTile(
            title: Text('Mês: ${limit.month}/${limit.year}'),
            subtitle: Text('Limite: R\$${limit.limit.toStringAsFixed(2)}'),
            trailing: Text(
              'Gasto: R\$${limit.spent.toStringAsFixed(2)}',
              style: TextStyle(
                color: limit.spent > limit.limit ? Colors.red : Colors.green,
              ),
            ),
          );
        },
      ),
    );
  }
}
