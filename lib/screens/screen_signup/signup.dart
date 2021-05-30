import 'package:flutter/material.dart';
import 'package:app_loja/helpers/validators.dart';
import 'package:app_loja/models/user.dart';
import 'package:app_loja/models/user_manager.dart';

import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  final User user = User();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Criar Conta'),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
              key: formkey,
              child: Consumer<UserManager>(builder: (_, userManager, __) {
                return ListView(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  children: <Widget>[
                    TextFormField(
                      decoration:
                          const InputDecoration(hintText: 'Nome Completo'),
                      enabled: !userManager.loading,
                      validator: (name) {
                        if (name.isEmpty) {
                          return 'Campo obrigatório';
                        } else if (name.trim().split(' ').length <= 1) {
                          return 'Preencha seu Nome completo';
                        }
                        return null;
                      },
                      onSaved: (name) => user.name = name,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'E-mail'),
                      keyboardType: TextInputType.emailAddress,
                      enabled: !userManager.loading,
                      validator: (email) {
                        if (email.isEmpty) {
                          return 'Campo obrigatório';
                        } else if (!emailValid(email)) return 'E-mail inválido';
                        return null;
                      },
                      onSaved: (email) => user.email = email,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(hintText: 'Senha'),
                      obscureText: true,
                      enabled: !userManager.loading,
                      validator: (pass) {
                        if (pass.isEmpty) {
                          return 'Campo obrigatório';
                        } else if (pass.length < 6) return 'Senha muito curta';
                        return null;
                      },
                      onSaved: (pass) => user.password = pass,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(hintText: 'Repita a senha'),
                      obscureText: true,
                      enabled: !userManager.loading,
                      validator: (pass) {
                        if (pass.isEmpty) {
                          return 'Campo obrigatório';
                        } else if (pass.length < 6) return 'Senha muito curta';
                        return null;
                      },
                      onSaved: (pass) => user.confirmPassword = pass,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                        height: 44,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(80.0)),
                          color: Theme.of(context).primaryColor,
                          disabledColor:
                              Theme.of(context).primaryColor.withAlpha(100),
                          textColor: Colors.white,
                          onPressed: userManager.loading
                              ? null
                              : () {
                                  if (formkey.currentState.validate()) {
                                    formkey.currentState.save();
                                    if (user.password != user.confirmPassword) {
                                      scaffoldkey.currentState
                                          .showSnackBar(const SnackBar(
                                        content: Text('Senhas não coincidem!'),
                                        backgroundColor: Colors.red,
                                      ));
                                      return;
                                    }
                                    userManager.signUp(
                                        user: user,
                                        onSuccess: () {
                                          Navigator.of(context).pop();
                                        },
                                        onFail: (e) {
                                          scaffoldkey.currentState
                                              .showSnackBar(SnackBar(
                                            content:
                                                Text('Falha ao entrar: $e'),
                                            backgroundColor: Colors.red,
                                          ));
                                        });
                                  }
                                },
                          child: userManager.loading
                              ? CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )
                              : const Text(
                                  'Criar conta',
                                  style: TextStyle(fontSize: 18),
                                ),
                        ))
                  ],
                );
              })),
        ),
      ),
    );
  }
}
