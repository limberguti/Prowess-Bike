// ignore_for_file: non_constant_identifier_names
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prowess_app/models/vehicleModel.dart';
import 'package:prowess_app/pages/AdminPage.dart';
import 'package:prowess_app/pages/loginPages.dart';
import 'package:prowess_app/pages/verify.dart';
import 'package:prowess_app/services/imageService.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:prowess_app/services/userService.dart';
import 'package:prowess_app/utils/constants.dart' as Constants;
import 'package:prowess_app/models/UserModel.dart' as UserModel;
import 'package:prowess_app/utils/validation.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterPageMotocycle extends StatefulWidget {
  const RegisterPageMotocycle({Key? key, required this.adm}) : super(key: key);
  final bool adm;
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPageMotocycle> {
  UserService userService = new UserService();

  String countryValue = "";
  String countryCheck = "";
  String stateValue = "";
  String cityValue = "";
  String addressCountry = "";
  late String _dropDownValue = "";
  int currentStep = 0;
  File? image;
  String? urlImagen;
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
  late DateTime? expiryLicense = DateTime.now();

  final license = TextEditingController();
  final typeLicense = TextEditingController();
  final brand = TextEditingController();
  final model = TextEditingController();
  final plate = TextEditingController();
  final numberRegist = TextEditingController();
  final owner = TextEditingController();
  final FotosService _fotosService = FotosService();

  List<GlobalKey<FormState>> _listKeys = [
    GlobalKey(),
    GlobalKey(),
    GlobalKey(),
  ];
  Future _selectImage(ImageSource source) async {
    final imageCamera = await ImagePicker().pickImage(source: source);
    if (imageCamera == null) return;
    final imageTemporary = File(imageCamera.path);
    image = imageTemporary;
    if (image != null) {
      urlImagen = await _fotosService.uploadImage(image!);
    }
    setState(() {});
  }

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
        Step(
          isActive: currentStep >= 2,
          title: const Icon(Icons.motorcycle),
          content: Form(
            key: _listKeys[2],
            autovalidateMode: AutovalidateMode.disabled,
            child: formMotor(),
          ),
        ),
      ];

  List emailsBD = [];

  @override
  Widget build(BuildContext context) {
    //recuperar Email de la base de datos
    userService.recuperarEmail().then((ls) {
      emailsBD = ls;
    });

    /* Modales o PopsUp del Registro */
    return SizedBox(
      width: 500,
      height: 800,
      child: Scaffold(
        appBar: PreferredSize(
          child: AppBar(
            backgroundColor: Constants.WHITE2,
            elevation: 0,
          ),
          preferredSize: Size.fromHeight(28.0),
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
                  /* Boton Flecha Atras */
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        fixedSize: Size(20, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        backgroundColor: Constants.WHITE3,
                      ),
                      onPressed: details.onStepCancel,
                      child: const Icon(
                        Icons.arrow_back,
                        color: Constants.GRAY,
                      ),
                    ),
                  ),
                  /* Boton Cancelar */
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        fixedSize: Size(155, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        backgroundColor: Constants.VINTAGE,
                      ),
                      onPressed: (widget.adm)
                          ? () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdminPage(),
                                  ),
                                )
                              }
                          : () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
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
                  /* Boton Flecha Delante */
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        fixedSize: Size(20, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
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
                  UserModel.User user = new UserModel.User();
                  user.name = name.text.trim();
                  user.surname = surname.text.trim();
                  user.docId = docId.text.trim();
                  user.age = age.text.trim();
                  user.nationality = countryValue;
                  user.address = address.text.trim();
                  user.phone = phone.text.trim();
                  user.urlimage = urlImagen;
                  user.cElec = email.text.trim();
                  user.cont = password.text.trim();
                  user.cod = us;

                  Vehicle vehicle = new Vehicle(
                    brand: brand.text.trim(),
                    licence: license.text.trim(),
                    model: model.text.trim(),
                    numberRegister: numberRegist.text.trim(),
                    owner: owner.text.trim(),
                    typeLicense: _dropDownValue,
                    plate: plate.text.trim(),
                    expiryLicense: expiryLicense,
                  );

                  user.vehicle = vehicle;
                  if (widget.adm) {
                    await _register();
                    await userService.saveUser(true, user);
                  } else {
                    await userService.saveUser(false, user);
                  }

                  print(
                      "_____----******************************completado****************************----_____");

                  /* PopsUp Estado correcto y Enviando solicitud */
                  showDialog(
                    context: context,
                    barrierDismissible: false,
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
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              SizedBox(
                                height: 15,
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
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              backgroundColor: Constants.VINTAGE,
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Aceptar',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: [
                                          Image.asset(
                                            "assets/images/solicitud.gif",
                                            height: 125.0,
                                            width: 125.0,
                                          ),
                                          Text(
                                            'Solicitud en proceso',
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            'Tu solicitud está siendo procesada.\nRecibirás un mensaje cuando se complete.',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                          style: OutlinedButton.styleFrom(
                                            //fixedSize: Size(155, 40),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                            backgroundColor: Constants.VINTAGE,
                                          ),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Aceptar',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            (widget.adm)
                                                ? Navigator.of(context)
                                                    .pushAndRemoveUntil(
                                                        MaterialPageRoute<Null>(
                                                    builder:
                                                        (BuildContext contex) {
                                                      //return new AdminPage();
                                                      return new VerifyScreen();
                                                    },
                                                  ),
                                                        (Route<dynamic>
                                                                route) =>
                                                            false)
                                                : Navigator.of(context)
                                                    .pushAndRemoveUntil(
                                                        MaterialPageRoute<Null>(
                                                    builder:
                                                        (BuildContext contex) {
                                                      return new LoginPage();
                                                    },
                                                  ),
                                                        (Route<dynamic>
                                                                route) =>
                                                            false);
                                          })
                                    ],
                                  );
                                },
                              );
                            },
                          )
                        ],
                      );
                    },
                  );
                } else {
                  setState(() => currentStep += 1);
                }
              }
            },
            onStepCancel: currentStep == 0
                ? (widget.adm)
                    ? () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminPage(),
                            ),
                          )
                        }
                    : () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          )
                        }
                : () {
                    setState(() => currentStep -= 1);
                  },
          ),
        ),
      ),
    );
  }

  /* Formulario 1 */
  Widget formUser1() {
    GlobalKey<CSCPickerState> _cscPickerKey = GlobalKey();
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Card(
      color: Constants.WHITE2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 10,
      child: Container(
        /*Imagen de Fondo*/
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/Motorcycle_bg.png'),
              fit: BoxFit.cover),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  if (!isKeyboard) _showImage(),
                  Container(
                    width: 335.0,
                    padding: EdgeInsets.only(top: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                ],
              ),
              Text(
                "Registrar motorizado",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 27,
                ),
              ),
              SizedBox(
                height: 20,
              ),
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
              TextFormField(
                  onTap: () {
                    address.text = Validation.upperValidation(address.text);
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
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    TextSpan(
                      text: "Nacionalidad ",
                      style: TextStyle(
                          fontSize: 13,
                          color: Color.fromARGB(255, 99, 99, 99),
                          fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                        text:
                            "                                                  ",
                        style: TextStyle(fontSize: 16, color: Colors.red)),
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
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Colors.white,
                    border: Border.all(color: Constants.TEXT_COLOR, width: 1)),

                ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                disabledDropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  color: Colors.grey.shade300,
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),

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
                height: 5,
              ),
              ListTile(
                title: Text(
                  "Seleccione una imagen de perfil",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .copyWith(color: Constants.BLACK),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(7.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Constants.VINTAGE2,
                        child: const Icon(
                          Icons.camera,
                          color: Colors.white,
                        ),
                        onPressed: () => _selectImage(ImageSource.camera),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Constants.VINTAGE2,
                        child: const Icon(
                          Icons.image,
                          color: Colors.white,
                        ),
                        onPressed: () => _selectImage(ImageSource.gallery),
                      ),
                    ),
                  ],
                ),
              ),
              image != null
                  ? ClipOval(
                      child: Image.file(
                        image!,
                        width: 160,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Text("")
            ],
          ),
        ),
      ),
    );
  }

  Widget formUser2() {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Card(
      color: Constants.WHITE2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
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
          child: Column(
            children: <Widget>[
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  if (!isKeyboard) _showImage(),
                  Container(
                    width: 335.0,
                    padding: EdgeInsets.only(top: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                ],
              ),
              Text(
                "Registrar motorizado",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 27,
                ),
              ),
              SizedBox(
                height: 20,
              ),
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
              /*
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: ListTile(
                        title: Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                      text:
                                          "Fecha de nacimiento",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color:
                                              Color.fromARGB(255, 99, 99, 99),
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text: " *",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.red)),
                                ],
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      )),
                  SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () async {
                        DateTime? _newDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime(DateTime.now().year - 18),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(DateTime.now().year - 18),
                            builder: (context, child) {
                              return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: Color.fromARGB(255, 89, 132,
                                          121), // header background color
                                      onPrimary:
                                          Colors.white70, // header text color
                                      onSurface: Colors
                                          .grey.shade800, // body text color
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        primary:
                                            Colors.black87, // button text color
                                      ),
                                    ),
                                  ),
                                  child: child!);
                            });
                        if (_newDate != null) {
                          setState(() {
                            expiryLicense = _newDate;
                          });
                        }
                        expiryLicense = _newDate;
                        print("***" + expiryLicense.toString() +  "***");
                      },
                      
                      child: Text(
                          '${expiryLicense?.day}-${expiryLicense?.month}-${expiryLicense?.year}'
                          ),
                          
                    ),
                    
                  ),
                ],
              ),

              */

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
                    //return Validation.emailValidation(value, emailsBD);
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
            ],
          ),
        ),
      ),
    );
  }

  Widget formMotor() {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Card(
      color: Constants.WHITE2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 15,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/Motorcycle_bg.png'),
              fit: BoxFit.cover),
        ),
        child: Padding(
          padding: EdgeInsets.all(11.0),
          child: Column(
            children: <Widget>[
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  if (!isKeyboard) _showImage(),
                  Container(
                    width: 335.0,
                    padding: EdgeInsets.only(top: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                ],
              ),
              Text(
                "Registrar motorizado",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 27,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(""),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.number,
                      controller: license,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(1.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        labelText: ' Número de licencia ',
                        labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      validator: (value) {
                        if (value!.isNotEmpty) {
                          return Validation.licenseValidation(value);
                        } else {
                          return 'No puede dejar este casillero vacío';
                        }
                      },
                    ),
/*                       child: ListTile(
                        title: Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
/*                                   TextSpan(
                                      text: "Tipo de licencia ",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color:
                                              Color.fromARGB(255, 99, 99, 99),
                                          fontWeight: FontWeight.bold)), */
                                ],
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ) */
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  SizedBox(
                    width: 150,
                    child: DropdownButtonFormField<String>(
                      elevation: 1,
                      dropdownColor: Constants.WHITE3,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(1.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      alignment: AlignmentDirectional.center,
                      hint: _dropDownValue == ""
                          ? Text(
                              ' Tipo de licencia',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )
                          : Text(
                              _dropDownValue,
                              style: TextStyle(color: Colors.black),
                            ),
                      value: _dropDownValue != '' ? _dropDownValue : null,
                      isExpanded: true,
                      iconSize: 30.0,
                      style: TextStyle(color: Colors.black),
                      items: ['A', 'A1', 'B', 'B1'].map(
                        (val) {
                          return DropdownMenuItem<String>(
                            value: val,
                            child: Text(val),
                          );
                        },
                      ).toList(),
                      onChanged: (val) {
                        setState(
                          () {
                            _dropDownValue = val.toString();
                          },
                        );
                      },
                      validator: (value) =>
                          value == null ? 'Seleccione una licencia' : null,
                    ),
                  ),
                ],
              ),
              Column(
                children: <Widget>[
                  Visibility(
                    visible: false,
                    child: TextFormField(
                      enabled: false,
                      controller: typeLicense,
                      decoration: InputDecoration(
                        labelText: _dropDownValue,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: brand,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(1.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: ' Marca del vehículo',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return Validation.brandValidation(value);
                  } else {
                    return 'Ingrese la marca de su vehículo';
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                onTap: () {
                  brand.text = Validation.upperValidation(brand.text);
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: model,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(1.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: ' Modelo del vehículo',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return Validation.modelValidation(value);
                  } else {
                    return 'No puede dejar este casillero vacío';
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: plate,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(1.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: ' Placa del vehículo',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return Validation.plateValidation(value);
                  } else {
                    return 'No puede dejar este casillero vacío';
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: numberRegist,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(1.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: ' Número de registro',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return Validation.numberRegistValidation(value);
                  } else {
                    return 'No puede dejar este casillero vacío';
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: owner,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(1.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: ' Dueño del vehículo',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return Validation.ownerValidation(value);
                  } else {
                    return 'Ingrese el nombre y apellido\nEjemplo: Christian Novoa';
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                children: const [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      ' Fecha de caducidad de la licencia',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 99, 99, 99),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  onPressed: () async {
                    DateTime? _newDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year - 1),
                        lastDate: DateTime(DateTime.now().year + 5),
                        builder: (context, child) {
                          return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: Color.fromARGB(255, 89, 132,
                                      121), // header background color
                                  onPrimary:
                                      Colors.white70, // header text color
                                  onSurface:
                                      Colors.grey.shade800, // body text color
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    primary:
                                        Colors.black87, // button text color
                                  ),
                                ),
                              ),
                              child: child!);
                        });
                    if (_newDate != null) {
                      setState(() {
                        expiryLicense = _newDate;
                      });
                    }
                    expiryLicense = _newDate;
                  },
                  child: Text(
                    '${expiryLicense?.day}-${expiryLicense?.month}-${expiryLicense?.year}',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    var user = await userService.register(email.text, password.text);
    us = user.uid;
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

/* Mostrar imagen */
_showImage() {
  return Container(
    width: 100.0,
    height: 100.0,
    decoration: BoxDecoration(
      color: Constants.WHITE,
    ),
    child: ClipOval(
      child: Image.asset('assets/images/ic_launcher.png'),
    ),
  );
}
