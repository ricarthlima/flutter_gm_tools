import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gm_tools/_core/colors.dart';
import 'package:flutter_gm_tools/auth/services/auth_service.dart';
import 'package:flutter_gm_tools/home/widgets/user_infos_drawer_header.dart';

class HomeScreen extends StatelessWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("GM Tools - Campanhas"),
      ),
      drawer: Drawer(
        width: min(512, MediaQuery.of(context).size.width),
        child: ListView(children: [
          UserInfosDrawerHeader(
            name: user.displayName!,
            creationDate:
                user.metadata.creationTime!.toString().substring(0, 10),
            lastSignin:
                user.metadata.lastSignInTime!.toString().substring(0, 10),
          ),
          const ListTile(
            leading: Icon(Icons.account_circle),
            title: Text("Minha conta"),
          ),
          ListTile(
            onTap: () {
              AuthService().deslogar();
            },
            leading: const Icon(Icons.logout),
            title: const Text("Sair"),
          ),
        ]),
      ),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              "assets/cleric.png",
              color: Colors.white.withOpacity(0.6),
              colorBlendMode: BlendMode.modulate,
            ),
          ),
          Container(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: MyColors.grey,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text("Juntar-se à campanha"),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text("Criar uma campanha"),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: [
              Row(
                children: const [
                  Text(
                    '"Para qual maravilhoso mundo embarcaremos hoje?"',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
