import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gm_tools/_core/colors.dart';
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
      body: Stack(
        children: [
          Container(
            alignment: Alignment.bottomRight,
            child: Image.asset("assets/cleric.png"),
          ),
          Container(
            margin: const EdgeInsets.only(right: 16, bottom: 8),
            alignment: Alignment.bottomRight,
            child: Text(
              "Zeri Ukuthula - Clériga de Eldath",
              style: TextStyle(
                fontSize: 16,
                color: MyColors.darkfgreen,
                fontWeight: FontWeight.w700,
                shadows: [
                  Shadow(
                    color: MyColors.white.withAlpha(100),
                    offset: const Offset(1, 1),
                    blurRadius: 6,
                  ),
                  Shadow(
                    color: MyColors.white.withAlpha(100),
                    offset: const Offset(-1, -1),
                    blurRadius: 6,
                  ),
                  Shadow(
                    color: MyColors.white.withAlpha(100),
                    offset: const Offset(1, 1),
                    blurRadius: 6,
                  ),
                  Shadow(
                    color: MyColors.white.withAlpha(100),
                    offset: const Offset(-1, -1),
                    blurRadius: 6,
                  )
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              width: min(300, MediaQuery.of(context).size.width),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: MyColors.white.withAlpha(50),
                borderRadius: BorderRadius.circular(16),
              ),
              child: SingleChildScrollView(
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
                        decoration: const InputDecoration(
                          label: Text("E-mail"),
                        ),
                        validator: (value) {
                          if (value == null || value == "") {
                            return "O valor de e-mail deve ser preenchido";
                          }
                          if (!value.contains("@") ||
                              !value.contains(".") ||
                              value.length < 4) {
                            return "O valor do e-mail deve ser válido";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _senhaController,
                        decoration: const InputDecoration(label: Text("Senha")),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.length < 4) {
                            return "Insira uma senha válida.";
                          }
                          return null;
                        },
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
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.length < 4) {
                                  return "Insira uma confirmação de senha válida.";
                                }
                                if (value != _senhaController.text) {
                                  return "As senhas devem ser iguais.";
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _nomeController,
                              decoration: const InputDecoration(
                                label: Text("Nome de Usuário"),
                              ),
                              validator: (value) {
                                if (value == null || value.length < 3) {
                                  return "Insira um nome maior.";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 32,
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
        ],
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
        } else {
          showSnackBar(
            context: context,
            mensagem:
                "Um e-mail de verificação foi enviado. Confira-o antes de fazer login.",
            isErro: false,
          );
          setState(() {
            isEntrando = true;
          });
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
