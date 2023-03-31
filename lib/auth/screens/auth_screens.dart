import 'package:flutter/material.dart';
import 'package:flutter_gm_tools/auth/services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../_core/show_snackbar.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmaController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();

  bool isEntrando = true;

  final _formKey = GlobalKey<FormState>();

  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: Colors.white,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "GM Tools",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 42,
                      fontFamily: GoogleFonts.changaOne().fontFamily,
                    ),
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(label: Text("E-mail")),
                  ),
                  TextFormField(
                    controller: _senhaController,
                    decoration: const InputDecoration(label: Text("Senha")),
                  ),
                  Visibility(
                    visible: isEntrando,
                    child: TextButton(
                      onPressed: () {
                        esqueciMinhaSenhaClicado();
                      },
                      child: const Text("Esqueceu a senha?"),
                    ),
                  ),
                  Visibility(
                    visible: !isEntrando,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _confirmaController,
                          decoration: const InputDecoration(
                            label: Text("Confirme a senha"),
                          ),
                        ),
                        TextFormField(
                          controller: _nomeController,
                          decoration: const InputDecoration(
                            label: Text("Nome de Usuário"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      botaoEntrarCadastrarClicado();
                    },
                    child: Text((isEntrando) ? "Entrar" : "Cadastrar"),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isEntrando = !isEntrando;
                      });
                    },
                    child: Text(
                      (isEntrando)
                          ? "Ainda não tem conta? Crie uma!"
                          : "Já tem uma conta? Que tal entrar?",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void botaoEntrarCadastrarClicado() {
    String email = _emailController.text;
    String senha = _senhaController.text;
    String nome = _nomeController.text;

    if (_formKey.currentState!.validate()) {
      if (isEntrando) {
        _entrarUsuario(email: email, senha: senha);
      } else {
        _criarUsuario(email: email, senha: senha, nome: nome);
      }
    }
  }

  _entrarUsuario({required String email, required String senha}) {
    authService.entrarUsuario(email: email, senha: senha).then((String? erro) {
      if (erro != null) {
        showSnackBar(context: context, mensagem: erro);
      }
    });
  }

  _criarUsuario({
    required String email,
    required String senha,
    required String nome,
  }) {
    authService.cadastrarUsuario(email: email, senha: senha, nome: nome).then(
      (String? erro) {
        if (erro != null) {
          showSnackBar(context: context, mensagem: erro);
        }
      },
    );
  }

  esqueciMinhaSenhaClicado() {
    String email = _emailController.text;
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController redefincaoSenhaController =
            TextEditingController(text: email);
        return AlertDialog(
          title: const Text("Confirme o e-mail para redefinição de senha"),
          content: TextFormField(
            controller: redefincaoSenhaController,
            decoration: const InputDecoration(label: Text("Confirme o e-mail")),
          ),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32))),
          actions: [
            TextButton(
              onPressed: () {
                authService
                    .redefincaoSenha(email: redefincaoSenhaController.text)
                    .then((String? erro) {
                  if (erro == null) {
                    showSnackBar(
                      context: context,
                      mensagem: "E-mail de redefinição enviado!",
                      isErro: false,
                    );
                  } else {
                    showSnackBar(context: context, mensagem: erro);
                  }

                  Navigator.pop(context);
                });
              },
              child: const Text("Redefinir senha"),
            ),
          ],
        );
      },
    );
  }
}
