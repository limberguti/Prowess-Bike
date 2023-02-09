import 'package:flutter/material.dart';
import 'package:prowess_app/components/modalComponent.dart';
import 'package:prowess_app/components/titleComponent.dart';
import 'package:prowess_app/models/motocycleModel.dart';
import 'package:prowess_app/pages/OrderMorPage.dart';
import 'package:prowess_app/pages/OrderPenMorPage.dart';
import 'package:prowess_app/pages/loginPages.dart';
import 'package:prowess_app/pages/updateMotorizado.dart';
import 'package:prowess_app/utils/constants.dart' as Constants;
import 'package:prowess_app/components/buttonComponent.dart';
import 'package:prowess_app/widgets/forgetPassword.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prowess_app/widgets/userInfo.dart';
import 'package:provider/provider.dart';
import 'package:prowess_app/provider/main_provider.dart';
import 'package:flutter/src/painting/circle_border.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
late String defaultiamge =
    "https://res.cloudinary.com/dydttkb7s/image/upload/v1645048970/ic_launcher_lhjvqs.png";

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key, required this.motocycle}) : super(key: key);
  final Motocycle motocycle;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

/* Pantalla Mi cuenta Motorizado */
class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context, listen: false);
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/Motorcycle_bg.png'),
              fit: BoxFit.cover),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              /* Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              child: TitleComponent(
                title: "Mi Cuenta",
              ),
            ) */
              SizedBox(
                height: 80,
              ),
              SizedBox(
                child: Column(
                  children: [
                    Text("Mi Cuenta",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 35,
                            color: Constants.BLACK))
                  ],
                ),
              ),

              /*Imagen*/
              SizedBox(
                height: 140,
                width: 140,
                child: Container(
                  decoration: BoxDecoration(
                      /* border: Border.all(
                        width: 3.0, color: Theme.of(context).highlightColor), */
                      //borderRadius: BorderRadius.circular(115.0),
                      image: DecorationImage(
                          image: NetworkImage(
                              (widget.motocycle.urlimage != null)
                                  ? widget.motocycle.urlimage.toString()
                                  : defaultiamge),
                          fit: BoxFit.contain)),
                  margin: EdgeInsets.symmetric(vertical: 25),
                ),
              ),
              SizedBox(height: 5.0),
              SizedBox(
                height: 65,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: ListTile(
                    title: Text(
                        "¡Bienvenid@ " +
                            widget.motocycle.name! +
                            "!" /* +
                            widget.motocycle.surname! */
                        ,
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w700)),
                    subtitle: Text(_auth.currentUser!.email ?? "",
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            color: Colors.black)),
                    /* leading: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        _showImage(widget.motocycle),
                      ],
                    ), */
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                  height: 48,
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.account_circle_rounded,
                          color: Color.fromARGB(174, 0, 0, 0),
                        ),
                        title: Text("Información de usuario",
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        //Aqui
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ModalComponent(
                                  body: userInfo(
                                      motocycle: widget.motocycle, auth: _auth),
                                );
                              });
                        },
                      ))),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                  height: 48,
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: ListTile(
                          leading: Icon(
                            Icons.security,
                            color: Color.fromARGB(174, 0, 0, 0),
                          ),
                          title: Text("Cambiar contraseña",
                              style: TextStyle(fontWeight: FontWeight.w500)),
                          //Aqui
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ModalComponent(
                                    body: ForgetPassword(),
                                  );
                                });
                          }))),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                  height: 48,
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.security_update_good,
                          color: Color.fromARGB(174, 0, 0, 0),
                        ),
                        title: Text("Actualizar datos",
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        //Aqui
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      //Nueva pagina (numeros de telefono)
                                      UpdateMororizado(
                                        motocycle: widget.motocycle,
                                        adm: false,
                                      )));
                        },
                      ))),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                  height: 48,
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: ListTile(
                        leading: Icon(Icons.shopping_cart,
                            color: Color.fromARGB(174, 0, 0, 0)),
                        title: Text("Historial de pedidos",
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        //Aqui
                        onTap: () {
                          //pagina Historial
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      //Nueva pagina (numeros de telefono)
                                      OrderMot(
                                        motocycle: mainProvider.motocycle,
                                        pendiente: true,
                                      )));
                        },
                      ))),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                  height: 48,
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.shopping_cart,
                          color: Color.fromARGB(174, 0, 0, 0),
                        ),
                        title: Text("Pedidos pendientes",
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        //Aqui
                        onTap: () {
                          //pagina Historial
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      //Nueva pagina (numeros de telefono)
                                      OrderPenMot(
                                        motocycle: mainProvider.motocycle,
                                        pendiente: true,
                                      )));
                        },
                      ))),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                  height: 48,
                  child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.help,
                          color: Color.fromARGB(174, 0, 0, 0),
                        ),
                        title: Text("Preguntas frecuentes",
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        //Aqui

                        onTap: () {
                          //pagina Preguntas Frecuentes
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(17)),
                                    title: Text(
                                      'Preguntas Frecuentes',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 23.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    content: Container(
                                        child: SingleChildScrollView(
                                            child: Column(children: [
                                      Text(
                                        '¿Cuáles son los servicios que ofrece ProwessBike?',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                          '\nProwessBike permite generar una interacción entre vendedor y cliente mediante la entrega de los productos de los vendedores registrados en la plataforma Prowessec.\n\n'),
                                      Text(
                                        '¿Quiénes pueden ingresar al sistema ProwessBike?',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                          '\nProwessBike está a disposición de aquellos motorizados que han sido aprobados por el administrador quien registrara a los mismos por medio de la aplicación y a su vez asigna un usuario y una contraseña para que el motorizado.\n\n'),
                                      Text(
                                        '¿Se puede recuperar la contraseña de un administrador en caso de olvidarla?',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                          '\nProwessBike cuenta con la posibilidad de recuperación de contraseña para los usuarios por medio de administradores.'),
                                    ]))),
                                    actions: <Widget>[
                                      FlatButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(17)),
                                        child: Container(
                                            padding:
                                                EdgeInsets.fromLTRB(0, 5, 0, 5),
                                            child: Text(
                                              'OK',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Constants.WHITE),
                                            )),
                                        color: Constants.VINTAGE,
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ));
                        },
                      ))),

              /* Boton Cerrar */
              Container(
                  margin: EdgeInsets.symmetric(vertical: 40),
                  child: ButtonComponent(
                    onPressed: () {
                      mainProvider.token = "";
                      mainProvider.adm = false;
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute<Null>(
                              builder: (BuildContext contex) {
                        return new LoginPage();
                      }), (Route<dynamic> route) => false);
                    },
                    text: "Cerrar sesión",
                    width: 120.0,
                  ))
            ],
          ),
        ),
      ),
    ));
  }
}

backAction(BuildContext context) {
  Navigator.pop(context);
}

_showImage(Motocycle motocycle) {
  var _imageSlected;
  return Container(
    width: 55.0,
    height: 130.0,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(75.0), color: Constants.WHITE),
    child: ClipOval(
        child: _imageSlected == false
            ? Image.asset(motocycle.urlimage ?? "")
            : null),
  );
}
