import 'package:flutter/material.dart';
import 'package:prowess_app/components/modalComponent.dart';
import 'package:prowess_app/models/motocycleModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ignore: must_be_immutable, camel_case_types
late String defaultiamge =
    "https://res.cloudinary.com/dydttkb7s/image/upload/v1645048970/ic_launcher_lhjvqs.png";

class userInfo extends StatelessWidget {
  const userInfo({Key? key, required this.motocycle, required this.auth})
      : super(key: key);

  final Motocycle motocycle;
  final FirebaseAuth auth;

  @override
  Widget build(BuildContext context) {
    return ModalCard(
      onClose: () {
        closeAction(context);
      },
      children: [
        Stack(
          //alignment: AlignmentDirectional.bottomStart,
          children: [
            Container(
              width: 150.0,
              height: 150.0,
              decoration: BoxDecoration(
                  /* border: Border.all(
                    width: 1,
                    color: Color.fromARGB(255, 69, 100, 69),
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(10.0), */
                  image: DecorationImage(
                image: NetworkImage((this.motocycle.urlimage != null)
                    ? this.motocycle.urlimage.toString()
                    : defaultiamge),
              )),
              //margin: EdgeInsets.symmetric(vertical: 15),
            ),
            /* Container(
              width: 325.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ), */
          ],
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                  "Nombre de usuario: " +
                      this
                          .motocycle
                          .name! /* +
                      " " +
                      this.motocycle.surname! */
                  ,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text(
                "Apellido: " + this.motocycle.surname!,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 17),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Text("Correo: " + this.auth.currentUser!.email!,
                  textAlign: TextAlign.left,
                  //style: Theme.of(context).textTheme.headline3,
                  style: TextStyle(
                      //color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.w400,
                      //fontStyle: FontStyle.italic,
                      fontSize: 17)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: Text("Teléfono: " + this.motocycle.phone!,
                  textAlign: TextAlign.left,
                  //style: Theme.of(context).textTheme.headline3,
                  style: TextStyle(
                      //color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.w400,
                      //fontStyle: FontStyle.italic,
                      fontSize: 17)),
            ),
          ]),
        )
      ],
    );
  }
}

closeAction(BuildContext context) {
  Navigator.of(context).pop();
}

//