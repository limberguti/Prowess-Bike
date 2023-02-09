import 'dart:ffi';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prowess_app/pages/AdminPage.dart';
import 'package:prowess_app/pages/loginPages.dart';
import 'package:prowess_app/pages/verify.dart';
import 'package:prowess_app/services/imageService.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:prowess_app/utils/constants.dart' as Constants;
import 'package:prowess_app/models/vehicleModel.dart';
import 'package:prowess_app/models/UserModel.dart' as UserModel;

final FirebaseAuth _auth = FirebaseAuth.instance;

class UserService {
  Future<void> saveUser(bool admin, UserModel.User user) async {
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference;
      Object obj = {
        "uid": "$user.cod",
        "name": user.name,
        "surname": user.surname,
        "Rol": "Motorizado",
        "id": user.docId,
        "age": user.age,
        "nationality": user.nationality,
        "address": user.address,
        "phone": user.phone,
        "urlimage": user.urlimage,
        "vehicle": {
          "licence": user.vehicle?.licence,
          "type_license": user.vehicle?.typeLicense,
          "expiry_license": user.vehicle?.expiryLicense?.toIso8601String(),
          "brand": user.vehicle?.brand,
          "model": user.vehicle?.model,
          "plate": user.vehicle?.plate,
          "number_register": user.vehicle?.numberRegister,
          "owner": user.vehicle?.owner,
        }
      };
      Object obj2 = {
        "uid": "$user.cod",
        "name": user.name,
        "surname": user.surname,
        "Rol": "Motorizado",
        "id": user.docId,
        "age": user.age,
        "nationality": user.nationality,
        "address": user.address,
        "phone": user.phone,
        "urlimage": user.urlimage,
        "email": user.cElec,
        "password": user.cont,
        "vehicle": {
          "licence": user.vehicle?.licence,
          "type_license": user.vehicle?.typeLicense,
          "expiry_license": user.vehicle?.expiryLicense?.toIso8601String(),
          "brand": user.vehicle?.brand,
          "model": user.vehicle?.model,
          "plate": user.vehicle?.plate,
          "number_register": user.vehicle?.numberRegister,
          "owner": user.vehicle?.owner,
        }
      };
      if (admin) {
        reference = FirebaseFirestore.instance.collection("usuario");
        await reference.add(obj);
      } else {
        reference =
            FirebaseFirestore.instance.collection('preregistro_motocycle');
        await reference.add(obj2);
      }
    });
  }

  Future<User> register(String email, String password) async {
    final User? user = (await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;
    return user!;
  }

  // retorna los correos electrónicos registrados
  // Provee a las pages => RegisterPageAdm & RegisterPageMotocycle
  Future<List> recuperarEmail() async {
    var rol = "";
    var email;
    List emailsBD = [];
    await FirebaseFirestore.instance
        .collection('usuario')
        .get()
        .then((value) => {
              value.docs.forEach((result) {
                rol = result.get("Rol");
                if (rol == "Motorizado") {
                  email = result.get("email");
                  emailsBD.add(email.toString());
                }
              })
            });
    return emailsBD;
  }

  //Retorna el nombre del motorizado hacia la page => detailsPage
  Future<String> recuperarNameMotorizado(String uidM) async {
    var name = "";
    var motorizado =
        await FirebaseFirestore.instance.collection("usuario").get();
    motorizado.docs.forEach((elem) {
      if (elem.get("Rol") == "Motorizado") {
        if (elem.get("uid") == uidM) {
          name = elem.get("name");
        }
      }
    });
    return name;
  }

  // //Retornar registro
  // Future<User> register(String email, String password) async {
  //   var user = await userService.register(email.text, password.text);
  //   us = user.uid;
  //   // ignore: unnecessary_null_comparison
  //   if (user != null) {
  //     setState(() {
  //       _success = true;
  //       _userEmail = user.email ?? '';
  //     });
  //   } else {
  //     _success = false;
  //   }
  // }
}
