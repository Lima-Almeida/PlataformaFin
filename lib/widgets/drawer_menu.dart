import 'package:flutter/material.dart';
import 'package:my_app/views/pages/metas.dart';
import 'package:my_app/views/pages/cadastroReceitas.dart';
import 'package:my_app/models/services/logout.dart'; // Para chamar o logout
import 'package:my_app/views/pages/listaCategorias.dart';

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
          // Adicionando o botão "Home" com a mesma funcionalidade que "Metas"
          ListTile(
            title: const Text('Home'),
            onTap: () {
              // Redireciona para a tela principal ou inicial
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CadastroReceitas()), // Aqui você pode substituir "Metas" pela sua tela inicial se for diferente
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
