import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:prowess_app/utils/constants.dart' as Constants;
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:prowess_app/utils/validation.dart';
import 'package:prowess_app/widgets/login/EmailPasswordComponent.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final emailController = TextEditingController();

class ScaffoldSnackbar {
  ScaffoldSnackbar(this._context);
  final BuildContext _context;

  /// The scaffold of current context.
  factory ScaffoldSnackbar.of(BuildContext context) {
    return ScaffoldSnackbar(context);
  }

  /// Helper method to show a SnackBar.
  void show(String message) {
    ScaffoldMessenger.of(_context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  User? user;
  late Map<String, dynamic> roles;
  @override
  void initState() {
    _auth.userChanges().listen(
          (event) => setState(() => user = event),
        );
    super.initState();
    onRefresh(FirebaseAuth.instance.currentUser);
  }

  onRefresh(userCred) {
    if (mounted) {
      setState(() {
        user = userCred;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      backgroundColor: Constants.WHITE,
      resizeToAvoidBottomInset: false,
      body: Builder(
        builder: (BuildContext context) {
          return ListView(
            padding: const EdgeInsets.all(2),
            children: <Widget>[
              SafeArea(child: Container(height: 30.0)),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 21.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    /* Imagen de Fondo */
                    image: DecorationImage(
                        image: AssetImage(
                          'assets/images/Motorcycle_bg.png',
                        ),
                        fit: BoxFit.cover),
                    //color: Theme.of(context).scaffoldBackgroundColor,
                    //borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(children: [
                    Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        /* Imagen Logo */
                        if (!isKeyboard) _showImage(),
                        Container(
                          width: 335.0,
                          padding: EdgeInsets.only(top: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                          ),
                        ),
                        Container(
                          child: Text('APLICACIÓN DE DELIVERY',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                              )),
                        ),
                      ],
                    ),
                    Container(
                      height: 40,
                    ),
                    if (!isKeyboard)
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Center(
                            child: Text('Iniciar sesión',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 28))),
                      ),
                    /*
                    Container(
                      height: 10,
                    ),
                    Container(
                      height: 15,
                    ),
                    
                    Text("Confianza y dedicación al servicio de la comunidad",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Constants.VINTAGE,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            fontSize: 18)),
                            */
                    SizedBox(height: 15.0),
                    const EmailPasswordForm(),
                  ])),
              Text("Confianza y Dedicación \nAl servicio de la comunidad",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                      fontSize: 12)),
              Container(
                height: 25,
              ),
            ],
          );
        },
      ),
    );
  }
}

class EmailTextControl extends StatelessWidget {
  const EmailTextControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Card(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /* Input del correo con su validacion*/
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: emailController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.email,
                      color: Theme.of(context).primaryColorDark),
                  hintText: 'usuario@gmail.com',
                  labelText: 'Correo electrónico o usuario',
                ),
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return Validation.emailValidation(value, null);
                  } else {
                    return 'No puede dejar este casillero vacio';
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PasswordTextControl extends StatelessWidget {
  const PasswordTextControl({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Card(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /* Input de la contraseña con su validacion*/
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(' ')),
                ],
                obscureText: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  icon: Icon(Icons.lock_outline,
                      color: Theme.of(context).primaryColorDark),
                  labelText: 'Contraseña',
                ),
                validator: (String? value) {
                  if (value!.isEmpty) return 'Ingrese una contraseña válida';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConfirmPasswordTextControl extends StatelessWidget {
  const ConfirmPasswordTextControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Padding(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.lock_outline,
                    color: Theme.of(context).primaryColorDark),
                labelText: 'Confirmar Contraseña',
                errorText: snapshot.error?.toString()),
          ),
        );
      },
    );
  }
}

class ChangeButtonControl extends StatelessWidget {
  const ChangeButtonControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return MaterialButton(
          color: Constants.VINTAGE,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 16.0),
            child: Text(
              'Cambiar',
              style: TextStyle(color: Constants.WHITE),
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constants.BORDER_RADIOUS)),
        );
      },
    );
  }
}

class SearchButtonControl extends StatelessWidget {
  SearchButtonControl({Key? key}) : super(key: key);

  void dispose() {
    emailController.dispose();
  }

  /* Boton de enviar correo de recuperacion */
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return MaterialButton(
          color: Constants.VINTAGE,
          onPressed: () {
            resetPassword(context);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
            child: Text(
              'Enviar correo de recuperación',
              style: TextStyle(
                  color: Constants.WHITE,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constants.BORDER_RADIOUS)),
        );
      },
    );
  }
}

Future resetPassword(BuildContext context) async {
  try {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailController.text.trim());
    print('Correo de recuperación enviado');
    Navigator.of(context).pop();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                "Se ha enviado un enlace a tu correo electrónico, revísalo por favor",
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center),
            actions: [
              Container(
                  child: Align(
                alignment: Alignment.bottomCenter,
                /* Boton Aceptar */
                child: TextButton(
                  style: OutlinedButton.styleFrom(
                    fixedSize: Size(100, 40),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Constants.BORDER_RADIOUS)),
                    backgroundColor: Constants.VINTAGE,
                  ),
                  child: Text(
                    "Aceptar",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Constants.WHITE),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              )),
            ],
          );
        });
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No se encontró ningún usuario con ese email.');
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Column(children: [
                Image.asset(
                  "assets/images/x-circle.png",
                ),
                Text('  \nE-mail no encontrado ',
                    style: TextStyle(fontWeight: FontWeight.bold))
              ]),
              content: Text(
                "No se encontró ningún usuario registrado con el correo ingresado",
                textAlign: TextAlign.center,
              ),
              actions: [
                Container(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    /* Boton Aceptar */
                    child: TextButton(
                      style: OutlinedButton.styleFrom(
                        fixedSize: Size(100, 40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                Constants.BORDER_RADIOUS)),
                        backgroundColor: Constants.VINTAGE,
                      ),
                      child: Text(
                        "Aceptar",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Constants.WHITE),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
              ],
            );
          });
    }
  }
}

_showImage() {
  return Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        color: Constants.WHITE,
      ),
      child: ClipOval(
        child: Image.asset('assets/images/ic_launcher.png'),
      ));
}

recoverPassword(BuildContext context) {
  return MaterialButton(onPressed: () {
    //newPasswordPopUp(context);
  });
}

/* forgetPassword(BuildContext context) {
  return MaterialButton(
      onPressed: () {
        openPopUp(context);
      },
      child: Text(
        "¿Olvidaste tu contraseña?",
        style: TextStyle(
            color: Constants.VINTAGE, decoration: TextDecoration.underline),
      ));
} */

/* PopUp - Olvidaste tu contraseña*/
void openPopUp(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Scaffold(
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.25),
          body: new Stack(
            children: [
              new Center(
                child: new ClipRect(
                  child: new BackdropFilter(
                      filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: new Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: new BoxDecoration(color: Colors.white),
                        child: new Center(
                          child: new SizedBox(
                            child: Card(
                              margin: EdgeInsets.all(20.0),
                              color: Constants.WHITE,
                              elevation: 5,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  /* Imagen de Fondo */
                                  image: DecorationImage(
                                      image: AssetImage(
                                        'assets/images/Motorcycle_bg.png',
                                      ),
                                      fit: BoxFit.cover),
                                  //color: Theme.of(context).scaffoldBackgroundColor,
                                  //borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      child: Row(children: [
                                        Expanded(
                                          flex: 5,
                                          child: Text(""),
                                        ),
                                        Expanded(
                                          child: IconButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              icon: Icon(
                                                Icons.close,
                                                color: Colors.black,
                                                size: 30.0,
                                              )),
                                        ),
                                      ]),
                                    ),
                                    Stack(
                                      alignment:
                                          AlignmentDirectional.bottomCenter,
                                      children: [
                                        _showImage(),
                                        Container(
                                          width: 325.0,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                          ),
                                        ),
                                        Container(
                                          child: Text('APLICACIÓN DE DELIVERY',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.normal,
                                              )),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    //Container(
                                    /* padding: EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      decoration: BoxDecoration(
                                        color: Constants.WHITE,
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ), */
                                    Column(children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: Text(
                                          'Recuperar Contraseña',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 28,
                                              color: Constants.BLACK),
                                          /* style: Theme.of(context)
                                                .textTheme
                                                .headline6, */
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      SizedBox(height: 15.0),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 20.0),
                                        child: Text(
                                          'Ingrese el correo electrónico con el que registró su cuenta',
                                          style: TextStyle(
                                              color: Constants.BLACK,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Container(
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          margin: EdgeInsets.only(
                                              left: 15, right: 15),
                                          elevation: 0,
                                          child: Column(
                                            children: [
                                              EmailTextControl(),
                                            ],
                                          ),
                                        ),
                                      ),
                                      recoverPassword(context),
                                      SizedBox(height: 10.0),
                                      SearchButtonControl(),
                                    ]),
                                    //),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      )),
                ),
              ),
            ],
          ));
    },
  );
}
