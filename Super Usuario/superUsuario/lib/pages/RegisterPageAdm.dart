import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prowess_app/pages/AdminPage.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:prowess_app/utils/constants.dart' as Constants;
import 'package:prowess_app/utils/validation.dart';
import 'package:prowess_app/services/userService.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterPageAdm extends StatefulWidget {
  const RegisterPageAdm({
    Key? key,
  }) : super(key: key);
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPageAdm> {
  UserService userService = new UserService();

  int currentStep = 0;
  String countryValue = "";
  String countryCheck = "";
  String stateValue = "";
  String cityValue = "";
  String addressCountry = "";
  late String us = "";
  // ignore: unused_field
  late bool? _success;
  late int cont;
  late bool _visible = true;
  late bool _valid = false;
  // ignore: unused_field
  late String _userEmail = '';

  final name = TextEditingController();
  final surname = TextEditingController();
  final nationality = TextEditingController();
  final address = TextEditingController();
  final phone = TextEditingController();

  final age = TextEditingController();
  final docId = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  late final GestureTapUpCallback? onTapUp;

  //Lista para guardar email de la BD
  List emailsBD = [];

  List<GlobalKey<FormState>> _listKeys = [
    GlobalKey(),
    GlobalKey(),
  ];

  List<Step> getSteps() => [
        Step(
          isActive: currentStep >= 0,
          title: const Icon(Icons.person),
          content: Form(
            key: _listKeys[0],
            autovalidateMode: AutovalidateMode.disabled,
            child: formUser1(),
          ),
        ),
        Step(
          isActive: currentStep >= 1,
          title: const Icon(Icons.contact_mail_outlined),
          content: Form(
            key: _listKeys[1],
            autovalidateMode: AutovalidateMode.disabled,
            child: formUser2(),
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    //Cargar los datos en la lista
    // Función llamada en el userService
    userService.recuperarEmail().then((ls) {
      emailsBD = ls;
    });
    return SizedBox(
      width: 500,
      height: 800,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Constants.WHITE,
          ),
          title: Text(
            "Registrar nuevo administrador",
            style: TextStyle(
              fontSize: 23,
              color: Colors.white,
            ),
          ),
          backgroundColor: Constants.VINTAGE,
          centerTitle: true,
        ),
        body: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Constants.VINTAGE),
          ),
          child: Stepper(
            controlsBuilder: (BuildContext context, ControlsDetails details) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        fixedSize: Size(20, 40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        backgroundColor: Constants.WHITE3,
                      ),
                      onPressed: details.onStepCancel,
                      child: const Icon(
                        Icons.arrow_back,
                        color: Constants.GRAY,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        fixedSize: Size(155, 40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        backgroundColor: Constants.VINTAGE,
                      ),
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AdminPage()),
                        )
                      },
                      child: Text(
                        "Cancelar",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        fixedSize: Size(20, 40),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        backgroundColor: Constants.WHITE3,
                      ),
                      onPressed: details.onStepContinue,
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Constants.GRAY,
                      ),
                    ),
                  ),
                ],
              );
            },
            type: StepperType.horizontal,
            steps: getSteps(),
            currentStep: currentStep,
            onStepContinue: () async {
              final isLastStep = currentStep == getSteps().length - 1;
              if (_listKeys[currentStep].currentState!.validate()) {
                if (isLastStep) {
                  await _register();
                  await _sendToServer();
                  print(
                      "_____----******************************completado****************************----_____");

                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: [
                                Image.asset(
                                  "assets/images/check-correct.png",
                                  height: 80.0,
                                  width: 80.0,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Registro Completado',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  'Su solicitud está siendo procesada por un administrador',
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            TextButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  backgroundColor: Constants.VINTAGE,
                                ),
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text('Aceptar',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                        ))),
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute<Null>(
                                          builder: (BuildContext contex) {
                                    return new AdminPage();
                                  }), (Route<dynamic> route) => false);
                                })
                          ],
                        );
                      });
                } else {
                  setState(() => currentStep += 1);
                }
              }
            },
            onStepCancel: currentStep == 0
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AdminPage()),
                    );
                  }
                : () {
                    setState(() => currentStep -= 1);
                  },
          ),
        ),
      ),
    );
  }

  Widget formUser1() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 10,
      child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/Motorcycle_bg.png'),
                fit: BoxFit.cover),
          ),
          child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.name,
                      controller: name,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(1.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: ' Nombre',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          print("************************" +
                              value +
                              "********************");
                          return Validation.nameValidation(value);
                        } else {
                          if (value.isEmpty) {
                            return 'No puede dejar este casillero vacío\nEjemplo: Diego';
                          }
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onTap: () {
                        name.text = Validation.upperValidation(name.text);
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.name,
                      controller: surname,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(1.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: ' Apellido',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return Validation.surnameValidation(value);
                        } else {
                          return 'No puede dejar este casillero vacío\nEjemplo: Padilla';
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: " ",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 255, 255, 255))),
                          TextSpan(
                            text: "Nacionalidad ",
                            style: TextStyle(
                                fontSize: 13,
                                color: Color.fromARGB(255, 99, 99, 99),
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                              text:
                                  "                                           ",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.red)),
                        ],
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    CSCPicker(
                      ///Enable disable state dropdown [OPTIONAL PARAMETER]
                      showStates: false,

                      /// Enable disable city drop down [OPTIONAL PARAMETER]
                      showCities: true,

                      ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                      flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,

                      ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                      dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                          border: Border.all(
                              color: Constants.TEXT_COLOR, width: 1)),

                      ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                      disabledDropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.grey.shade300,
                          border: Border.all(
                              color: Colors.grey.shade300, width: 1)),

                      ///placeholders for dropdown search field
                      countrySearchPlaceholder: "País de origen",
                      stateSearchPlaceholder: "State",
                      citySearchPlaceholder: "City",

                      ///labels for dropdown
                      countryDropdownLabel: "País de origen",
                      stateDropdownLabel: "*State",
                      cityDropdownLabel: "*City",

                      ///Default Country
                      defaultCountry: DefaultCountry.Ecuador,

                      ///Disable country dropdown (Note: use it with default country)
                      //disableCountry: true,

                      ///selected item style [OPTIONAL PARAMETER]
                      selectedItemStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),

                      ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                      dropdownHeadingStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),

                      ///DropdownDialog Item style [OPTIONAL PARAMETER]
                      dropdownItemStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),

                      ///Dialog box radius [OPTIONAL PARAMETER]
                      dropdownDialogRadius: 10.0,

                      ///Search bar radius [OPTIONAL PARAMETER]
                      searchBarRadius: 10.0,

                      ///triggers once country selected in dropdown
                      onCountryChanged: (value) {
                        setState(() {
                          ///store value in country variable
                          countryValue = value;
                          nationality.text = value;
                        });
                      },

                      ///triggers once state selected in dropdown
                      onStateChanged: (value) {
                        setState(() {
                          ///store value in state variable
                          stateValue = "$value";
                        });
                      },

                      ///triggers once city selected in dropdown
                      onCityChanged: (value) {
                        setState(() {
                          ///store value in city variable
                          cityValue = "$value";
                        });
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      onTap: () {
                        surname.text = Validation.upperValidation(surname.text);
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.multiline,
                      controller: address,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(1.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: ' Ciudad de residencia',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return Validation.adressValidation(value);
                        } else {
                          return 'No puede dejar este casillero vacío\nEjemplo: Quito';
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        onTap: () {
                          address.text =
                              Validation.upperValidation(address.text);
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        keyboardType: TextInputType.number,
                        controller: phone,
                        maxLength: 10,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(1.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          labelText: ' Celular',
                          labelStyle: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            return Validation.phoneValidation(value);
                          } else {
                            return 'No puede dejar este casillero vacío';
                          }
                        }),
                  ]))),
    );
  }

  Widget formUser2() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 15,
      //key: _form2Key,
      child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/Motorcycle_bg.png'),
                fit: BoxFit.cover),
          ),
          child: Padding(
              padding: EdgeInsets.all(11.0),
              child: Column(children: <Widget>[
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  controller: age,
                  maxLength: 2,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(1.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: ' Edad',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  validator: (value) {
                    if (value!.isNotEmpty) {
                      return Validation.ageValidation(value);
                    } else {
                      return 'No puede dejar este casillero vacío';
                    }
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.number,
                  controller: docId,
                  maxLength: 10,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(1.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: ' Cédula',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  validator: (value) {
                    if (value!.isNotEmpty) {
                      return Validation.idValidation(value);
                    } else {
                      return 'No puede dejar este casillero vacío';
                    }
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: email,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(1.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: ' Email',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  validator: (value) {
                    if (value!.isNotEmpty) {
                      return Validation.emailValidation(value, emailsBD);
                    } else {
                      return 'No puede dejar este casillero vacío';
                    }
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                Text(""),
                TextFormField(
                  onTap: () {
                    email.text = Validation.spaceValidation(email.text);
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  maxLength: 15,
                  obscuringCharacter: "*",
                  controller: password,
                  obscureText: _visible,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(1.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: ' Contraseña',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
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
                  validator: (value) {
                    if (value!.isNotEmpty) {
                      return Validation.passwordValidation(value);
                    } else {
                      return 'No puede dejar este casillero vacío';
                    }
                  },
                )
              ]))),
    );
  }

  Future<void> _sendToServer() async {
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference;
      reference = FirebaseFirestore.instance.collection("usuario");
      await reference.add({
        "uid": "$us",
        "name": name.text.trim(),
        "surname": surname.text.trim(),
        "Rol": "Admin",
        "id": docId.text.trim(),
        "age": age.text.trim(),
        "nationality": countryValue,
        "address": address.text.trim(),
        "phone": phone.text.trim(),
      });
    });
  }

  Future<void> _register() async {
    final User? user = (await _auth.createUserWithEmailAndPassword(
      email: email.text,
      password: password.text,
    ))
        .user;
    us = user!.uid;
    // ignore: unnecessary_null_comparison
    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email ?? '';
      });
    } else {
      _success = false;
    }
  }
}
