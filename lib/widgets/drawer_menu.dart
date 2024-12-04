import 'package:flutter/material.dart';
import 'package:my_app/views/pages/metas.dart';
import 'package:my_app/views/pages/cadastroReceitas.dart';
import 'package:my_app/models/services/logout.dart'; // Para chamar o logout
import 'package:my_app/views/pages/listaCategorias.dart';
import 'package:my_app/views/pages/relatorios.dart'; // Import da página de Relatórios

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu Lateral',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CadastroReceitas()), // Substitua "CadastroReceitas" pela sua tela inicial
              );
            },
          ),
          ListTile(
            title: const Text('Metas'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Metas()),
              );
            },
          ),
          ListTile(
            title: const Text('Categorias'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ViewCategoriesScreen()),
              );            
            },
          ),
          // Novo botão para Relatórios
          ListTile(
            title: const Text('Relatórios'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Relatorios()), // Substitua por sua classe da página de relatórios
              );
            },
          ),
          ListTile(
            title: const Text('Sair'),
            onTap: () {
              logout(context); // Chama a função de logout
            },
          ),
        ],
      ),
    );
  }
}
