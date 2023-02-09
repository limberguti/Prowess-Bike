import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:prowess_app/components/buttonComponent.dart';
import 'package:prowess_app/components/modalComponent.dart';
import 'package:prowess_app/components/badgeComponent.dart';
//import 'package:prowess_app/components/textInputComponent.dart';
//import 'package:prowess_app/components/titleComponent.dart';
import 'package:prowess_app/pages/loginPages.dart';
import 'package:prowess_app/provider/main_provider.dart';
import 'package:prowess_app/utils/constants.dart' as Constants;
import 'package:prowess_app/utils/validation.dart';

// ignore: must_be_immutable
class ForgetPassword extends StatefulWidget {
  //Function()? onSubmit;

  ForgetPassword({
    Key? key,
  }) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  //final _passwordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  var newPassword = " ";

  @override
  void dispose() {
    newPasswordController.dispose();
    super.dispose();
  }

  final currentUser = FirebaseAuth.instance.currentUser;

  final _formKey = GlobalKey<FormState>();

  //bool checkCurrentPasswordValid = true;

  changePassword() async {
    try {
      await currentUser!.updatePassword(newPassword);
      FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<Null>(builder: (BuildContext contex) {
        return new LoginPage();
      }), (Route<dynamic> route) => false);
      /*Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );*/
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            backgroundColor: Constants.VINTAGE,
            content: Text(
              "Su contraseña se ha cambiado de manera exitosa. \nPor favor ingrese nuevamente!",
              style: TextStyle(
                  color: Constants.WHITE, fontWeight: FontWeight.bold),
            ),
            duration: const Duration(seconds: 20)),
      );
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context, listen: false);
    return ModalCard(
      onClose: () {
        closeAction(context);
      },
      children: [
        Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Badge(
              icon: Icon(Icons.lock,
                  color: Color.fromARGB(221, 41, 41, 41), size: 45),
              radius: 75,
            ),
            /* Container(
              width: 325.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ), */
          ],
        ),
        SingleChildScrollView(
            /*decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
          ),*/
            child: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 5.0),
              Flexible(
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Cambiar contraseña",
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 25),
                        ),
                        /*TextFormField(
                          decoration: InputDecoration(
                            hintText: "Contraseña actual",
                            errorText: checkCurrentPasswordValid
                                ? null
                                : "Please double check your current password",
                          ),
                          controller: _passwordController,
                        ),*/
                        SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 7),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              hintText: "Nueva contraseña"),
                          controller: newPasswordController,
                          obscureText: true,
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              return Validation.passwordValidation(value);
                            } else {
                              return 'No puede dejar esta casillero vacio';
                            }
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(left: 7),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            hintText: "Repita la contraseña",
                          ),
                          obscureText: true,
                          controller: repeatPasswordController,
                          validator: (value) {
                            return newPasswordController.text == value
                                ? null
                                : "Porfavor valide la contraseña introducida";
                          },
                        )
                      ],
                    )),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      newPassword = newPasswordController.text;
                    });
                    changePassword();
                    mainProvider.token = "";
                    mainProvider.adm = false;
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Constants.VINTAGE,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  fixedSize: Size(100, 40),
                ),
                child: Text(
                  "Aceptar",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: Constants.WHITE),
                ),
              )
            ],
          ),
        ))
      ],
    );
  }
}

closeAction(BuildContext context) {
  Navigator.of(context).pop();
}
// ignore: must_be_immutable