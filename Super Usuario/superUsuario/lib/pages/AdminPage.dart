import 'package:flutter/material.dart';
import 'package:prowess_app/pages/RegisterPageAdm.dart';
import 'package:prowess_app/pages/RegisterPageMotocycle.dart';
import 'package:prowess_app/pages/loginPages.dart';
import 'package:prowess_app/utils/constants.dart' as Constants;
import 'package:prowess_app/list/MotocycleList.dart';
import 'package:provider/provider.dart';
import 'package:prowess_app/provider/main_provider.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Constants.WHITE,
      /* drawer: ExitMenu(),
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Constants.WHITE,
          title: Text("Menú administrador",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold))),*/

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        //Imagen de fondo
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/Motorcycle_bg.png'),
                fit: BoxFit.cover),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //Aqui se maneja el titulo
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Aqui se maneja el titulo
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Text("Menú",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text("Administrador",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold)),
                        ),

                        //Aqui se maneja el icono de persona
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: ClipOval(
                                child: Icon(Icons.account_circle_outlined,
                                    color: Constants.BLACK, size: 100)),
                          ),
                        ),

                        //Aqui se maneja el titulo de bienvenido
                        Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text("¡Bienvenid@!",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold))),

                        //Desde aqui se manejan los botones

                        //Boton registrar motorizados
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MaterialButton(
                            minWidth: 300,
                            height: 50,
                            color: Constants.WHITE,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    Constants.BORDER_RADIOUS)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegisterPageMotocycle(
                                            adm: true,
                                          )));
                            },
                            child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 10,
                                children: [
                                  Icon(Icons.person_add_alt_1_outlined),
                                  Text("Registrar motorizados",
                                      style: TextStyle(
                                        color: Constants.BLACK,
                                      ))
                                ]),
                          ),
                        ),

                        //Boton Ver motorizados
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MaterialButton(
                            minWidth: 300,
                            height: 50,
                            color: Constants.WHITE,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    Constants.BORDER_RADIOUS)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MotocycleList(
                                            admin: true,
                                          )));
                            },
                            child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 10,
                                children: [
                                  Icon(Icons.motorcycle_outlined),
                                  Text("Ver motorizados",
                                      style: TextStyle(
                                        color: Constants.BLACK,
                                      ))
                                ]),
                          ),
                        ),

                        //Boton Revisar Solicitudes
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MaterialButton(
                            minWidth: 300,
                            height: 50,
                            color: Constants.WHITE,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    Constants.BORDER_RADIOUS)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MotocycleList(
                                            admin: false,
                                          )));
                            },
                            child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 10,
                                children: [
                                  Icon(Icons.verified_outlined),
                                  Text("Revisar solicitudes",
                                      style: TextStyle(
                                        color: Constants.BLACK,
                                      ))
                                ]),
                          ),
                        ),

                        //Boton Registrar administrador
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MaterialButton(
                            minWidth: 300,
                            height: 50,
                            color: Constants.WHITE,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    Constants.BORDER_RADIOUS)),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterPageAdm()));
                            },
                            child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 10,
                                children: [
                                  Icon(Icons.add_moderator_outlined),
                                  Text("Registrar administrador",
                                      style: TextStyle(
                                        color: Constants.BLACK,
                                      ))
                                ]),
                          ),
                        ),

                        //Boton Preguntas Frecuentes
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MaterialButton(
                            minWidth: 300,
                            height: 50,
                            color: Constants.WHITE,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    Constants.BORDER_RADIOUS)),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                        title: Text('Preguntas Frecuentes',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 26)),
                                        content: Container(
                                            child: SingleChildScrollView(
                                                child: Column(children: [
                                          Text(
                                              '¿Cuáles son los servicios que ofrece ProwessBike?',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                            '\nProwessBike permite generar una interacción entre vendedor y cliente mediante la entrega de los productos de los vendedores registrados en la plataforma Prowessec.\n\n',
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                              '¿Quiénes pueden ingresar al sistema ProwessBike?',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                            '\nProwessBike está a disposición de aquellos motorizados que han sido aprobados por el administrador quien registrara a los mismos por medio de la aplicación y a su vez asigna un usuario y una contraseña para que el motorizado.\n\n',
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                              '¿Se puede recuperar la contraseña de un administrador en caso de olvidarla?',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text(
                                            '\nProwessBike cuenta con la posibilidad de recuperación de contraseña para los usuarios por medio de administradores.',
                                            textAlign: TextAlign.center,
                                          ),
                                        ]))),
                                        actions: <Widget>[
                                          /* Boton Ok */
                                          Container(
                                            child: Align(
                                              alignment: Alignment.bottomCenter,
                                              child: TextButton(
                                                style: OutlinedButton.styleFrom(
                                                  fixedSize: Size(100, 40),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .circular(Constants
                                                              .BORDER_RADIOUS)),
                                                  backgroundColor:
                                                      Constants.VINTAGE,
                                                ),
                                                child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      'OK',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17,
                                                          color:
                                                              Constants.WHITE),
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
                            child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 10,
                                children: [
                                  Icon(Icons.question_mark_outlined),
                                  Text("Preguntas frecuentes",
                                      style: TextStyle(
                                        color: Constants.BLACK,
                                      ))
                                ]),
                          ),
                        ),

                        //Boton Cerrar Sesion
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: MaterialButton(
                            minWidth: 150,
                            height: 50,
                            color: Constants.VINTAGE,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    Constants.BORDER_RADIOUS)),
                            onPressed: () {
                              mainProvider.token = "";
                              mainProvider.adm = false;
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            },
                            child: Text(
                              "Cerrar Sesión",
                              style: TextStyle(
                                  color: Constants.WHITE,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),

                        //Aqui terminan los botones
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
