import 'package:app_loja/models/user.dart';
import 'package:app_loja/models/user_manager.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:app_loja/helpers/validators.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passController = TextEditingController();

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: const Text('Entrar'),
        centerTitle: true,
        actions: <Widget>[buildFlatButton(context)],
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: buildForm(context),
        ),
      ),
    );
  }

  Form buildForm(BuildContext context) {
    return Form(
        key: formkey,
        child: Consumer<UserManager>(
          builder: (_, userManager, child) {
            return ListView(
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              children: <Widget>[
                buildTextFormField(userManager),
                const SizedBox(
                  height: 16,
                ),
                buildTextFormField2(userManager),
                child,
                buildSizedBox(),
                buildSizedBox2(userManager, context)
              ],
            );
          },
          child: buildAlign(),
        ));
  }

  SizedBox buildSizedBox2(UserManager userManager, BuildContext context) {
    return SizedBox(
      height: 44,
      child: buildRaisedButton(userManager, context),
    );
  }

  SizedBox buildSizedBox() {
    return const SizedBox(
      height: 16,
    );
  }

  Align buildAlign() {
    return Align(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () {},
        padding: EdgeInsets.zero,
        child: const Text('Esqueci minha senha'),
      ),
    );
  }

  FlatButton buildFlatButton(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      onPressed: () {
        Navigator.of(context).pushReplacementNamed('/signup');
      },
      textColor: Colors.white,
      child: const Text(
        'CRIAR CONTA',
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  RaisedButton buildRaisedButton(
      UserManager userManager, BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      onPressed: userManager.loading
          ? null
          : () {
              if (formkey.currentState.validate()) {
                userManager.signIn(
                  user: User(
                      email: emailController.text,
                      password: passController.text),
                  onFail: (e) {
                    scaffoldkey.currentState.showSnackBar(SnackBar(
                      content: Text('Falha ao entrar: $e'),
                      backgroundColor: Colors.red,
                    ));
                  },
                  onSuccess: () {
                    Navigator.of(context).pop();
                  },
                );
              }
            },
      color: Theme.of(context).primaryColor,
      disabledColor: Theme.of(context).primaryColor.withAlpha(100),
      textColor: Colors.white,
      child: userManager.loading
          ? const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            )
          : const Text(
              'Entrar',
              style: TextStyle(fontSize: 18),
            ),
    );
  }

  TextFormField buildTextFormField2(UserManager userManager) {
    return TextFormField(
      controller: passController,
      enabled: !userManager.loading,
      decoration: const InputDecoration(hintText: 'Senha'),
      autocorrect: false,
      obscureText: true,
      validator: (pass) {
        if (pass.isEmpty || pass.length < 6) {
          return 'Senha inválida';
        }
        return null;
      },
    );
  }

  TextFormField buildTextFormField(UserManager userManager) {
    return TextFormField(
      controller: emailController,
      enabled: !userManager.loading,
      decoration: const InputDecoration(hintText: 'E-mail'),
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      validator: (email) {
        if (!emailValid(email)) return 'E-mail inválido';
        return null;
      },
    );
  }
}
