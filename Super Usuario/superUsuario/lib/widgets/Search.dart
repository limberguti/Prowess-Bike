import 'package:firestore_search/firestore_search.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:prowess_app/models/vehicleModel.dart';
import 'package:prowess_app/utils/constants.dart';
import 'package:prowess_app/models/motocycleModel.dart';
import 'package:prowess_app/card/MotocycleListCard.dart';
import 'package:prowess_app/utils/constants.dart' as Constants;
import 'package:google_fonts/google_fonts.dart';
import 'package:prowess_app/pages/updateMotorizado.dart';
import 'package:prowess_app/models/preregister_motocycle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prowess_app/services/google_auth_api.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as dev;

final FirebaseAuth _auth = FirebaseAuth.instance;

class SearchFeed extends StatefulWidget {
  const SearchFeed({Key? key, required this.admin}) : super(key: key);
  final bool admin;
  @override
  _SearchFeedState createState() => _SearchFeedState();
}

class _SearchFeedState extends State<SearchFeed> {
  late String defaultimg =
      "https://res.cloudinary.com/dydttkb7s/image/upload/v1645048970/ic_launcher_lhjvqs.png";

  deleteUser(String uid) async {
    print(uid);
    try {
      var response = await http.post(
          Uri.parse(
              "https://us-central1-prowess-bike.cloudfunctions.net/app/deleteUser"),
          body: {
            "UID": uid,
          });
      print(response.body);
    } catch (e) {
      print(e);
    }
  }

  var motocycle2 = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: buscar(),
    );
  }
  
//Solo se aplican cambios a la hora de buscar - Recomendacion: Area de mantenimiento
//Llevar optimizacion de codigo
  Widget buscar() {
    bool mostrarBusqueda = false;
    String colection;
    Stream<QuerySnapshot> motocycle;
    if (widget.admin) {
      motocycle = FirebaseFirestore.instance
          .collection("usuario")
          .where("Rol", isEqualTo: "Motorizado")
          .snapshots();

      colection = "usuario";
    } else {
      motocycle = FirebaseFirestore.instance
          .collection('preregistro_motocycle')
          .snapshots();
      colection = 'preregistro_motocycle';
      
    }
    final size = MediaQuery.of(context).size;
    //Aqui se maneja el feed de busqueda 
    return Column(
      children: [
        SizedBox(
          height: 20.0,
        ),
        Row(
          children: [
            const SizedBox(
              width: 50.0,
            ),
            Expanded(
                child: FirestoreSearchBar(
              tag: 'test',

            )),
            const SizedBox(
              width: 50.0,
            ),
          ],
        ),
        Expanded(
          child: FirestoreSearchResults.builder(
            tag: 'test',
            firestoreCollectionName: colection,
            searchBy: 'name',
            initialBody: Center(
              child: ListView(children: [
                MotocycleCard(
                  currentMotocycle: motocycle,
                  adm: widget.admin,
                )
              ]),
            ),
            
            
            dataListFromSnapshot: Motocycle().dataListFromSnapshot,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<Motocycle>? dataList = snapshot.data;
                if (dataList!.isEmpty) {
                  return const Center(
                    child: Text('Sin resultados'),
                  );
                }

                return ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      final Motocycle data = dataList[index];
                      return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 10.0),
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          width: size.width * .80,
                          decoration: BoxDecoration(
                              color: Theme.of(context).secondaryHeaderColor,
                              borderRadius: BorderRadius.circular(20.0),
                              border:
                                  Border.all(width: 2.0, color: Colors.white)),
                          child: Column(
                            children: [
                              listMotoycleSearch(data),
                            ],
                          ));
                    });
              }

              if (snapshot.connectionState == ConnectionState.done) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('No Results Returned'),
                  );
                }
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        )
      ],
    );
  }

  Widget listMotoycleSearch(Motocycle data) {
    final size = MediaQuery.of(context).size;
    final vehiculoData = data.vehicle;
    final preregisterMotocycle aux = findSearch(data.id.toString());
    aux.vehicle = vehiculoData;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            width: size.width * .80,
            decoration: BoxDecoration(
                color: Theme.of(context).secondaryHeaderColor,
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(width: 2.0, color: Constants.VINTAGE)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(5.0),
              leading: CircleAvatar(
                backgroundImage: NetworkImage((data.urlimage == null)
                    ? defaultimg
                    : data.urlimage.toString()),
                radius: 30,
                backgroundColor: Constants.WHITE,
              ),
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(data.name! + ' ' + data.surname.toString(),
                    style: GoogleFonts.raleway(
                        color: Constants.VINTAGE,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        textStyle: Theme.of(context).textTheme.headline4)),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:[
                      Icon(Icons.menu,
                                    color: Colors.black),
                  Text("CI: " + data.id.toString(),
                      style: GoogleFonts.roboto(
                          color: Colors.black,
                          fontSize: 12.0,
                          textStyle: Theme.of(context).textTheme.headline4)),
                  SizedBox(
                    height: 10,
                  ),
                    ],
                  ),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.location_on_outlined, color: Colors.black),
                      Expanded(child: Text(data.address.toString())),
                    ],
                  ),
                ],
              ),
              trailing: IconButton(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(top: 20),
                icon: Icon(Icons.more_horiz_outlined),
                color: Constants.BLACK,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Container(
                          child: Column(children: [
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
                                    Icons.cancel,
                                    color: Colors.black,
                                    size: 30.0,
                                  )),
                            ),
                          ]),
                        ),
                        Text("Motorizado " + data.name.toString() + "     ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left),
                      ])),
                      content: SingleChildScrollView(
                        child: Container(
                          child: ListBody(
                            children: <Widget>[
                              Container(
                                child: CircleAvatar(
                                  foregroundImage: NetworkImage(
                                    (data.urlimage == null)
                                        ? defaultimg
                                        : data.urlimage.toString(),
                                  ),
                                  radius: 90,
                                  backgroundColor: WHITE,
                                ),
                              ),
                               Padding(padding: EdgeInsets.only(top: 30)),
                              Container(
                                child: Column(
                                  children: [
                                    Row(
                                       mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                      
                                                children: [
                                                  
                                                   Icon(Icons.person,
                                                          color: Constants
                                                              .VINTAGE),
                                                  Text(' | Edad: '),
                                        Row(
                                          children: [
                                            Text("  "+data.age.toString()),
                                           
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.phone,
                                                color: Constants.VINTAGE),
                                        Text(' | Teléfono: '),
                                        Row(
                                          children: [
                                            Text("  "+data.phone.toString()),
                                            
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                         Icon(Icons.language,
                                                color: Constants.VINTAGE),
                                        Text(' | Nacionalidad: '),
                                        Row(
                                          
                                          children: [
                                           
                                            Text("  "+ data.nationality.toString()),
                                            
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.motorcycle,
                                                color: Constants.VINTAGE),
                                        Text(' | Tipo licencia: '),
                                        Row(
                                          children: [
                                             
                                            Text("  "+data.vehicle!.typeLicense
                                                .toString()),
                                           
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.motorcycle,
                                                color: Constants.VINTAGE),
                                        Text(' | Nº licencia: '),
                                        Row(
                                          children: [
                                            Text("  "+data.vehicle!.licence
                                                .toString()),
                                            
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.motorcycle,
                                                color: Constants.VINTAGE),
                                        Text(' | Placa: '),
                                        Row(
                                          children: [
                                            Text(data.vehicle!.plate == null
                                                ? "Ninguna"
                                                : "  "+data.vehicle!.plate
                                                    .toString()),
                                            
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(Icons.motorcycle,
                                                color: Constants.VINTAGE),
                                        Text(' | Nº registro: '),
                                        Row(
                                          children: [
                                            Text("  "+data.vehicle!.numberRegister
                                                .toString()),
                                            
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      actions: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                            top: BorderSide(
                                width: 0.7, color: Constants.GRAY),
                          )),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  changePassword(data);
                                },
                                icon: Icon(
                                  Icons.key,
                                  color: Colors.black,
                                ),
                                tooltip: 'Cambiar contraseña',
                              ),
                              
                              opc(aux, widget.admin, data.id.toString()),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                    if (widget.admin) {
                                      deleteUser(data.uid.toString());
                                    }
                                    deleteSearch(data.uid.toString());
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              'Usuario Eliminado',
                                              textAlign: TextAlign.center,
                                            ),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: [
                                                  Image.asset(
                                                    "assets/images/delete.gif",
                                                    height: 125.0,
                                                    width: 125.0,
                                                  ),
                                                  Text(
                                                    'Exitoso',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                  child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text('Aceptar',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                          ))),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  })
                                            ],
                                          );
                                        });
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: BLACK,
                                    size: 30.0,
                                  ),
                                  tooltip: 'Eliminar usuario',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ))
      ],
    );
  }

  Widget opc(var motocy, bool adm, String id) {
    if (adm) {
      return IconButton(
          onPressed: () {
            Navigator.push<void>(
              context,
              MaterialPageRoute<void>(
                  builder: (BuildContext context) => UpdateMororizado(
                        motocycle: motocy,
                        adm: widget.admin,
                      )),
            );
          },
          icon: Icon(
            Icons.edit,
            color: Colors.black,
            size: 30.0,
          ),
          tooltip: 'Modificar usuario');
    } else {
      return IconButton(
          onPressed: () async {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      'Usuario Aceptado',
                      textAlign: TextAlign.center,
                    ),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: [
                          Image.asset(
                            "assets/images/check_solicitud.gif",
                            height: 125.0,
                            width: 125.0,
                          ),
                          Text(
                            'Exitoso',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                          child: Align(
                              alignment: Alignment.center,
                              child: Text('Aceptar',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ))),
                          onPressed: () async {
                            //await imprimirPre(motocy);
    
                            await _register(motocy);
                            await _sendToServer(motocy);
                            await deletMotocyle(motocy);
                               
                            //deletMotocyle(motocy);
                            //await sendEmail(motocy);
                            Navigator.pop(context);
                          })
                    ],
                  );
                });

            showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                      title: Text("Error"),
                      content: Text("Ingrese otro correo"),
                    ));

            Navigator.pop(context);
          },
          icon: Icon(
            Icons.check,
            color: Colors.black,
            size: 30.0,
          ));
    }
  }

  Future<void> _register(preregisterMotocycle motocy) async {
    final User? user = (await _auth.createUserWithEmailAndPassword(
      email: motocy.email.toString(),
      password: motocy.password.toString(),
    ))
        .user;
    await user!.sendEmailVerification();
    motocy.uid = user.uid;
  }

  Future<void> _sendToServer(preregisterMotocycle motocy) async {
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference;
      reference = FirebaseFirestore.instance.collection('usuario');
      try{
      await reference.add({
        "uid": motocy.uid,
        "name": motocy.name,
        "surname": motocy.surname,
        "Rol": "Motorizado",
        "id": motocy.id,
        "age": motocy.age,
        "nationality": motocy.nationality,
        "address": motocy.address,
        "phone": motocy.phone,
        "urlimage": motocy.urlimage,
        "email": motocy.email,
        "vehicle": {
          "licence": motocy.vehicle!.licence,
          "type_license": motocy.vehicle!.typeLicense,
          "expiry_license": motocy.vehicle!.expiryLicense.toString(),
          "brand": motocy.vehicle!.brand,
          "model": motocy.vehicle!.model,
          "plate": motocy.vehicle!.plate,
          "number_register": motocy.vehicle!.numberRegister,
          "owner": motocy.vehicle!.owner
        }
      });
      }on Exception catch(e){
        print("***ERROR***" + e.toString());
      }
    });
  }


  Future<void> deletMotocyle(preregisterMotocycle motocy) async {
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference =
          FirebaseFirestore.instance.collection('preregistro_motocycle');
      QuerySnapshot pd = await reference.get();
      String docUid = "";
      for (var doc in pd.docs) {
        if (motocy.id == doc.get("id").toString()) {
          docUid = doc.id;
          break;
        }
      }
      await reference.doc(docUid).delete();
    });
  }
  
/*
  Future<void> deletMotocyle(preregisterMotocycle motocy) async {
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference =
          FirebaseFirestore.instance.collection('preregistro_motocycle');
      CollectionReference reference2 =
          FirebaseFirestore.instance.collection('usuario');
      QuerySnapshot pd = await reference.get();
      String docUid = "";
      for (var doc in pd.docs) {
        if (motocy.id == doc.get("id").toString()) {
          docUid = doc.id;
          break;
        }
      }
      await reference.doc(docUid).delete();
      await reference2.doc(docUid).delete();
    });
  }
  */

  Future sendEmail(preregisterMotocycle motocy) async {
    final user = await GoogleAuthApi.signIn();

    if (user == null) return;

    final email = user.email;
    final auth = await user.authentication;
    final token = auth.accessToken!;

    print('Authenticated: $email');

    final smtpServer = gmailSaslXoauth2(email, token);
    final message = Message()
      ..from = Address(email, 'Total Prowess')
      ..recipients = ['$motocy.email']
      ..subject = 'Solicitud Total Prowess'
      ..html =
          '<h1>Bienvenido $motocy.name !</h1>\n<p>$motocy.name te informamos que tu solicitud de trabajo como repartidor motorizado de nuestra empresa Total Prowess a sido aceptada, por lo que puedes ya ingresar a nuestra aplicación y observar lo que tenemos para ti.</p>';
    //..text = 'Te informamos que tu solicitud de trabajo como repartidor motorizado de nuestra empresa Total Prowess a sido aceptada, por lo que puedes ya ingresar a nuestra aplicación y observar lo que tenemos para ti.';

    try {
      await send(message, smtpServer);
    } on MailerException catch (e) {
      print(e);
    }
  }

  Future changePassword(var motocy) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Desea enviar un correo de recuperación  a " +
                motocy.name.toString()),
            content: Text("Se enviará un correo de recuperación a " +
                motocy.email.toString()),
            actions: [
              TextButton(
                  onPressed: () {
                    dev.log(motocy.email.toString());
                    resetPassword(motocy.email.toString());
                    Navigator.of(context).pop();
                  },
                  child: Text("Enviar")),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Cancelar")),
            ],
          ));
  Future resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Se ha enviado el correo de recuperación"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Aceptar")),
            ],
          );
        });
  }

  Future<void> deleteSearch(String id) async {
    var idB = "";
    await FirebaseFirestore.instance
        .collection("usuario")
        .get()
        .then((data) => {
              data.docs.forEach((result) {
                idB = result.get("uid");
                if (idB == id) {
                  result.reference.delete();
                }
              })
            });
  }

  Future<void> registerSearch(String id) async {
    preregisterMotocycle pre = new preregisterMotocycle();
    var idB = "";
    await FirebaseFirestore.instance
        .collection("preregistro_motocycle")
        .get()
        .then((data) => {
              data.docs.forEach((result) { 
                idB = result.get("id");
                if (idB == id) {
                  pre = result.reference.get() as preregisterMotocycle;
                }
              })
            });
  }

  preregisterMotocycle findSearch(String id) {
    preregisterMotocycle pre = new preregisterMotocycle();
    Vehicle vehiculo = new Vehicle();
    var idB = "";
    FirebaseFirestore.instance
        .collection("preregistro_motocycle")
        .get()
        .then((data) => {
              data.docs.forEach((result) {
                idB = result.get("id");
                if (idB == id) {
                  pre.address = result.get("address");
                  pre.age = result.get("age");
                  pre.email = result.get("email");
                  pre.id = result.get("id");
                  pre.name = result.get("name");
                  pre.nationality = result.get("nationality");
                  pre.password = result.get("password");
                  pre.phone = result.get("phone");
                  pre.rol = "Motorizado";
                  pre.surname = result.get("surname");
                  //pre.uid = result.get("uid");
                  pre.urlimage = result.get("urlimage");
                  //vehiculo = result.get("vehicle");
                  pre.vehicle = result.get("vehicle").toString() as Vehicle?;
                }
              })
            });
            
            return pre;
  }

  Future<void> imprimirPre(preregisterMotocycle pre)async{
  print("*******************Valores del Preregistro**************************");
            print(pre.address.toString());
            print(pre.age.toString());
            print(pre.email.toString());
            print(pre.id.toString());
            print(pre.name.toString());
            print(pre.nationality.toString());
            print(pre.password.toString());
            print(pre.phone.toString());
            print(pre.rol.toString());
            print(pre.surname.toString());
            print(pre.uid.toString());
            print("Imagen: " + pre.urlimage.toString());
            print(pre.vehicle.toString());
  }

}



