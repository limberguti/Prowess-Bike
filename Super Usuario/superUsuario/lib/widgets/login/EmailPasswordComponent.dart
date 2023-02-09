import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:prowess_app/pages/AdminPage.dart';
import 'package:prowess_app/pages/mainPage.dart';
import 'package:prowess_app/provider/main_provider.dart';
import 'package:prowess_app/utils/constants.dart' as Constants;
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as dev;
import 'package:prowess_app/utils/validation.dart';
import 'package:prowess_app/pages/RegisterPageMotocycle.dart';

import '../../pages/loginPages.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
late bool _visible = true;
late bool _valid = false;

class EmailPasswordForm extends StatefulWidget {
  const EmailPasswordForm({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EmailPasswordFormState();
}

class _EmailPasswordFormState extends State<EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? respuesta;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Constants.BORDER_RADIOUS),
                  side: BorderSide(
                    //width: 1,
                    color: Color.fromARGB(41, 42, 46, 52),
                  ),
                ),
                margin: EdgeInsets.only(left: 15, right: 15),
                elevation: 1,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _emailController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'usuario@gmail.com',
                          label: Text(
                            'Correo electrónico o usuario',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          prefixIcon: Icon(Icons.email,
                              color: Theme.of(context).primaryColorDark),
                        ),
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            respuesta = Validation.emailValidation(value, null);
                          } else {
                            respuesta = " Por favor ingrese su correo";
                          }
                          return respuesta;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Constants.BORDER_RADIOUS),
                  side: BorderSide(
                    color: Color.fromARGB(41, 42, 46, 52),
                  ),
                ),
                margin: EdgeInsets.only(left: 15, right: 15),
                elevation: 1,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: TextFormField(
                        controller: _passwordController,
                        obscuringCharacter: "*",
                        obscureText: _visible,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          label: Text(
                            'Contraseña',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          prefixIcon: Icon(Icons.lock,
                              color: Theme.of(context).primaryColorDark),
                          suffixIcon: Container(
                            child: MaterialButton(
                                height: 10,
                                minWidth: 10,
                                child: Icon((_visible == false)
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded),
                                textTheme: ButtonTextTheme.normal,
                                onPressed: () async {
                                  if (_valid) {
                                    setState(() {
                                      _visible = true;
                                    });
                                    _valid = false;
                                  } else {
                                    setState(() {
                                      _visible = false;
                                    });
                                    _valid = true;
                                  }
                                }),
                          ),
                        ),
                        validator: (String? value) {
                          if (value!.isEmpty)
                            return ' Por favor ingrese su contraseña';
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 25,
            ),

            /* Botones Ingresar y Deseo Trabajar aqui */
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: AlignmentDirectional.center,
                    child: MaterialButton(
                      minWidth: 300,
                      height: 45,
                      color: Constants.VINTAGE,
                      shape: RoundedRectangleBorder(
                          side:
                              BorderSide(color: Color.fromARGB(41, 42, 46, 52)),
                          borderRadius:
                              BorderRadius.circular(Constants.BORDER_RADIOUS)),
                      child: Column(
                        children: [
                          Text(
                            'Ingresar',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await _signInWithEmailAndPassword();
                        }
                      },
                    ),
                    //),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: MaterialButton(
                      minWidth: 300,
                      height: 45,
                      color: Constants.WHITE,

                      //color: Constants.VINTAGE,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Constants.VINTAGE),
                          borderRadius:
                              BorderRadius.circular(Constants.BORDER_RADIOUS)),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPageMotocycle(
                                      adm: false,
                                    )));
                      },
                      child: Text(
                        "Deseo trabajar aquí",
                        style: TextStyle(
                            color: Constants.VINTAGE,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        //style: TextStyle(color: Constants.WHITE),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            /* PopUp-Recuerda-Signo de Exclamacion */
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10.0),
                forgetPassword(context),
                IconButton(
                  icon: Icon(
                    Icons.error_sharp,
                    color: Constants.VINTAGE,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text('Recuerda',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Constants.VINTAGE,
                                      fontWeight: FontWeight.bold)),
                              content: Text(
                                'Para un mejor uso de la aplicación.\nActiva la opción de GPS en tu dispositivo.',
                                textAlign: TextAlign.center,
                              ),
                              actions: [
                                /* Boton Aceptar */
                                Container(
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: TextButton(
                                      style: OutlinedButton.styleFrom(
                                        fixedSize: Size(100, 40),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Constants.BORDER_RADIOUS)),
                                        backgroundColor: Constants.VINTAGE,
                                      ),
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'OK',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17,
                                                color: Constants.WHITE),
                                          )),
                                      //color: Constants.VINTAGE,
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ));
                  },
                  tooltip: 'Ayuda',
                ),
              ],
            ),
          ],
        ),
      ),

      ///),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmailAndPassword() async {
    final mainProvider = Provider.of<MainProvider>(context, listen: false);
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user!;
      dev.log(user.toString(), name: "INGRESAR");
      String userId = FirebaseAuth.instance.currentUser!.uid;

      FirebaseFirestore.instance
          .collection("usuario")
          .where("uid", isEqualTo: userId)
          .get()
          .then((value) => {
                value.docs.forEach((result) {
                  var sections = result.get("Rol");
                  dev.log(sections, name: "Sections - Login Pages");
                  if (sections == "Admin") {
                    mainProvider.token = user.uid;
                    mainProvider.adm = true;
                    adminRol();
                    ScaffoldSnackbar.of(context)
                        .show('${user.email} Bienvenido Administrador');
                  } else if (sections == "Motorizado") {
                    dev.log(result.data().toString(),
                        name: "Doc data from Motorizado");
                    mainProvider.motocycle = json.encode(result.data());

                    dev.log(mainProvider.motocycle,
                        name: "Main Provider Motorizado - LoginPage");
                    mainProvider.token = user.uid;
                    mainProvider.adm = false;

                    motocycleRol(mainProvider.motocycle);
                    ScaffoldSnackbar.of(context)
                        .show('${user.email} Bienvenido Usuario');
                  } else {
                    ScaffoldSnackbar.of(context)
                        .show('${user.email} Bienvenido Usuario');
                  }
                })
              });
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Column(children: [
                  Image.asset(
                    "assets/images/x-circle.png",
                  ),
                  Text('  \nError al iniciar sesión ',
                      style: TextStyle(fontWeight: FontWeight.bold))
                ]),
                content: Text(
                    'Por favor revise que su correo electrónico y contraseña sean correctos.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Constants.BLACK)),
                actions: [
                  Container(
                    child: Align(
                      child: TextButton(
                        style: OutlinedButton.styleFrom(
                          fixedSize: Size(100, 40),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  Constants.BORDER_RADIOUS)),
                          backgroundColor: Constants.VINTAGE,
                        ),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'OK',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Constants.WHITE),
                            )),
                        //color: Constants.VINTAGE,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  )
                ],
              ));
    }
  }

  Future<dynamic> adminRol() {
    return Navigator.push(
        context, MaterialPageRoute(builder: (context) => AdminPage()));
  }

//A TRAVÉS DEL UID HACER UNA CONSULTA Y PASAR COMO PARÁMETRO EL MOTOCYCLE
  Future<dynamic> motocycleRol(String motocycle) {
    return Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MainPage(
                  titulo: "Motorizado",
                  motocycle: motocycle,
                )));
  }
}

forgetPassword(BuildContext context) {
  return MaterialButton(
      onPressed: () {
        openPopUp(context);
      },
      child: Text(
        "¿Olvidaste tu contraseña?",
        style: TextStyle(
            fontSize: 16,
            color: Constants.VINTAGE,
            decoration: TextDecoration.underline),
      ));
}
