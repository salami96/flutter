import 'package:flutter/material.dart';
import 'package:loja/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _passController = TextEditingController();
  final _registerPassController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    return DefaultTabController(
        length: 2,
        child: Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text("Entrar / Criar Conta"),
              centerTitle: true,
              bottom: TabBar(
                indicatorColor: Colors.white,
                tabs: <Widget>[
                  Tab(
                    icon: Icon(Icons.account_circle),
                  ),
                  Tab(
                    icon: Icon(Icons.person_add),
                  ),
                ],
              ),
            ),
            body: ScopedModelDescendant<UserModel>(
              builder: (context, child, model) {
                if (model.isLoading)
                  return Center(child: CircularProgressIndicator());
                return TabBarView(
                  children: <Widget>[
                    Form(
                        key: _formKey,
                        child: ListView(
                          padding: EdgeInsets.all(16),
                          children: <Widget>[
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(hintText: "E-mail"),
                              keyboardType: TextInputType.emailAddress,
                              validator: (text) {
                                if (text.isEmpty || !text.contains("@"))
                                  return "E-mail inválido!";
                              },
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              controller: _passController,
                              decoration: InputDecoration(hintText: "Senha"),
                              obscureText: true,
                              validator: (text) {
                                if (text.isEmpty || text.length < 6)
                                  return "Senha inválida!";
                              },
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: FlatButton(
                                onPressed: () {
                                  if (_emailController.text.isEmpty) {
                                    _scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                      content:
                                          Text("Insira seu E-mail para recuperação!"),
                                      backgroundColor:
                                          Colors.redAccent,
                                      duration: Duration(seconds: 5),
                                    ));
                                  } else {
                                    model.recoveryPass(_emailController.text);
                                    _scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                      content:
                                          Text("Confira no seu E-mail!"),
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      duration: Duration(seconds: 5),
                                    ));
                                  }
                                },
                                child: Text(
                                  "Esqueci minha senha",
                                  textAlign: TextAlign.right,
                                ),
                                textColor: primaryColor,
                                padding: EdgeInsets.zero,
                              ),
                            ),
                            SizedBox(height: 16),
                            SizedBox(
                              height: 50,
                              child: RaisedButton(
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    model.signIn(
                                        email: _emailController.text,
                                        pass: _passController.text,
                                        onSuccess: _onLoginSuccess,
                                        onFail: _onLoginFail);
                                  }
                                },
                                child: Text(
                                  "Entrar",
                                  style: TextStyle(fontSize: 18),
                                ),
                                textColor: Colors.white,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        )),
                    Form(
                        key: _registerFormKey,
                        child: ListView(
                          padding: EdgeInsets.all(16),
                          children: <Widget>[
                            TextFormField(
                              controller: _nameController,
                              decoration:
                                  InputDecoration(hintText: "Nome Completo"),
                              validator: (text) {
                                if (text.isEmpty) return "Nome inválido!";
                              },
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              controller: _registerEmailController,
                              decoration: InputDecoration(hintText: "E-mail"),
                              keyboardType: TextInputType.emailAddress,
                              validator: (text) {
                                if (text.isEmpty || !text.contains("@"))
                                  return "E-mail inválido!";
                              },
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              controller: _registerPassController,
                              decoration: InputDecoration(hintText: "Senha"),
                              obscureText: true,
                              validator: (text) {
                                if (text.isEmpty || text.length < 6)
                                  return "Senha inválida!";
                              },
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            TextFormField(
                              controller: _addressController,
                              decoration: InputDecoration(hintText: "Endereço"),
                              validator: (text) {
                                if (text.isEmpty) return "Endereço inválido!";
                              },
                            ),
                            SizedBox(height: 16),
                            SizedBox(
                              height: 50,
                              child: RaisedButton(
                                onPressed: () {
                                  if (_registerFormKey.currentState
                                      .validate()) {
                                    Map<String, dynamic> userData = {
                                      "name": _nameController.text,
                                      "email": _registerEmailController.text,
                                      "address": _addressController.text,
                                    };
                                    model.signUp(
                                        userData: userData,
                                        pass: _registerPassController.text,
                                        onSuccess: _onRegisterSuccess,
                                        onFail: _onRegisterFail);
                                  }
                                },
                                child: Text(
                                  "Criar conta",
                                  style: TextStyle(fontSize: 18),
                                ),
                                textColor: Colors.white,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        )),
                  ],
                );
              },
            )));
  }

  void _onRegisterSuccess() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Usuário criado com sucesso!"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 5),
    ));
    Future.delayed(Duration(seconds: 5)).then((_) {
      Navigator.of(context).pop();
    });
  }

  void _onRegisterFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao criar usuário!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 5),
    ));
  }

  void _onLoginSuccess() {
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
    });
  }

  void _onLoginFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao Entrar!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 5),
    ));
  }
}
