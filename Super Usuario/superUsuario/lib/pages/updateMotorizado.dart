// ignore_for_file: deprecated_member_use
import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prowess_app/models/motocycleModel.dart';
import 'package:prowess_app/pages/orderPage.dart';
import 'package:prowess_app/pages/settingsPage.dart';
import 'package:prowess_app/services/imageService.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:prowess_app/utils/constants.dart' as Constants;
import 'package:prowess_app/utils/validation.dart';
import 'AdminPage.dart';

class UpdateMororizado extends StatefulWidget {
  const UpdateMororizado({Key? key, required this.motocycle, required this.adm})
      : super(key: key);

  final Motocycle motocycle;
  final bool adm;
  @override
  _UpdateMororizadoState createState() => _UpdateMororizadoState();
}

class _UpdateMororizadoState extends State<UpdateMororizado> {
  String countryValue = "";
  String countryCheck = "";
  String stateValue = "";
  String cityValue = "";
  String addressCountry = "";
  late String _dropDownValue = widget.motocycle.vehicle!.typeLicense!;
  int currentStep = 0;
  File? image;
  late String? urlImagen = widget.motocycle.urlimage;
  late String us = "";
  // ignore: unused_field
  late bool? _success;
  // ignore: unused_field
  late String _userEmail = '';
  late String? nationality_temp = widget.motocycle.nationality;

  late var name = TextEditingController(text: widget.motocycle.name);
  late var surname = TextEditingController(text: widget.motocycle.surname);
  late var nationality =
      TextEditingController(text: widget.motocycle.nationality);
  late var address = TextEditingController(text: widget.motocycle.address);
  late var phone = TextEditingController(text: widget.motocycle.phone);

  late var age = TextEditingController(text: widget.motocycle.age);
  late var docId = TextEditingController(text: widget.motocycle.id);
  final email = TextEditingController();
  final password = TextEditingController();

  late var license =
      TextEditingController(text: widget.motocycle.vehicle!.licence);
  late var typeLicense = TextEditingController();
  late DateTime? expiryLicense = widget.motocycle.vehicle!.expiryLicense;

  DateTime _dateTime = new DateTime(2022);

  late var brand = TextEditingController(text: widget.motocycle.vehicle!.brand);
  late var model = TextEditingController(text: widget.motocycle.vehicle!.model);
  late var plate = TextEditingController(text: widget.motocycle.vehicle!.plate);
  late var numberRegist =
      TextEditingController(text: widget.motocycle.vehicle!.numberRegister);
  late var owner = TextEditingController(text: widget.motocycle.vehicle!.owner);
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

  //Ventana PopUp Cancelar Actualizacion de Datos
  // ignore: unused_element
  void _validation(BuildContext context) async {
    final result = await showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Column(children: [
              Image.asset(
                "assets/images/x-circle.png",
                //height: 80.0,
                //width: 80.0,
              ),
              //Text('  Alert Dialog Title. ')
            ]),
            content: Text(
              '¿Estás seguro de continuar?\nLos datos no se actualizarán.',
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              Row(
                children: <Widget>[
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Constants.VINTAGE),
                      fixedSize: Size(120, 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      backgroundColor: Constants.WHITE,
                    ),
                    child: Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Constants.VINTAGE,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      fixedSize: Size(120, 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      backgroundColor: Constants.VINTAGE,
                    ),
                    child: Text(
                      'Aceptar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ],
              ),
            ],
          );
        });
    if (result) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _validation(context);
        return Future.value(false);
      },
      child: SizedBox(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Constants.WHITE,
            ),
            title: Text(
              "Actualizar motorizado",
              style: TextStyle(
                fontSize: 23,
                color: Colors.white,
              ),
            ),
            backgroundColor: Constants.VINTAGE,
            centerTitle: false,
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
                        child:
                            const Icon(Icons.arrow_back, color: Constants.GRAY),
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
                        onPressed: () => _validation(context),
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
                        child: const Icon(Icons.arrow_forward,
                            color: Constants.GRAY),
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
                    await _sendToServer();
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
                                    height: 50.0,
                                    width: 50.0,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    'Actualización Completada',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Exitoso',
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              Container(
                                child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: TextButton(
                                        style: OutlinedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0)),
                                          backgroundColor: Constants.VINTAGE,
                                          fixedSize: Size(100, 40),
                                        ),
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Text('Aceptar',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ))),
                                        onPressed: () {
                                          if (!widget.adm) {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute<Null>(
                                                        builder: (BuildContext
                                                            contex) {
                                              return new SettingsPage(
                                                  motocycle: widget.motocycle);
                                            }),
                                                    (Route<dynamic> route) =>
                                                        false);
                                          } else {
                                            Navigator.of(context)
                                                .pushAndRemoveUntil(
                                                    MaterialPageRoute<Null>(
                                                        builder: (BuildContext
                                                            contex) {
                                              return new AdminPage();
                                            }),
                                                    (Route<dynamic> route) =>
                                                        false);
                                          }
                                        })),
                              ),
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
                      Navigator.of(context).pop();
                    }
                  : () {
                      setState(() => currentStep -= 1);
                    },
            ),
          ),
        ),
      ),
    );
  }

  Widget formUser1() {
    GlobalKey<CSCPickerState> _cscPickerKey = GlobalKey();
    nationality_temp = widget.motocycle.nationality;
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                              return 'No puede dejar este casillero vacío\nEjemplo: Diego';
                            }
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          }),
                      SizedBox(
                        height: 8,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: " ",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Color.fromARGB(255, 255, 255, 255))),
                            TextSpan(
                                text: "Nacionalidad: " + '$nationality_temp',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Color.fromARGB(255, 99, 99, 99),
                                    fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    "                                             ",
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
                        countrySearchPlaceholder: "Cambiar país de origen",
                        stateSearchPlaceholder: "State",
                        citySearchPlaceholder: "City",

                        ///labels for dropdown
                        countryDropdownLabel: "Cambiar país de origen",
                        stateDropdownLabel: "*State",
                        cityDropdownLabel: "*City",

                        ///Default Country
                        //defaultCountry: DefaultCountry.Ecuador,

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
                            nationality_temp = '';
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
                      RichText(
                        text: countryValue == ''
                            ? TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Icon(Icons.info_outline,
                                        size: 13,
                                        color:
                                            Color.fromARGB(255, 115, 115, 115)),
                                  ),
                                  TextSpan(
                                      text:
                                          "  Puede dejar el campo vacío si no desea cambiar su país                                  ",
                                      style: TextStyle(
                                          fontSize: 13,
                                          color:
                                              Color.fromARGB(255, 66, 66, 66))),
                                ],
                              )
                            : TextSpan(text: "", style: TextStyle(fontSize: 0)),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: Constants.VINTAGE2,
                                  child: const Icon(
                                    Icons.camera,
                                    color: Colors.white,
                                  ),
                                  onPressed: () =>
                                      _selectImage(ImageSource.camera)),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  color: Constants.VINTAGE2,
                                  child: const Icon(
                                    Icons.image,
                                    color: Colors.white,
                                  ),
                                  onPressed: () =>
                                      _selectImage(ImageSource.gallery)),
                            ),
                          ],
                        ),
                      ),
                    ]))));
  }

  Widget formUser2() {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 15,
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
                ]))));
  }

  Widget formMotor() {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 15,
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/Motorcycle_bg.png'),
                  fit: BoxFit.cover),
            ),
            child: Padding(
                padding: EdgeInsets.all(11.0),
                child: Column(children: <Widget>[
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
                        /* child: ListTile(
                            title: Column(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                          text: "Tipo de licencia ",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color.fromARGB(
                                                  255, 99, 99, 99),
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
                          ) */
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      SizedBox(
                        width: 150,
                        child: DropdownButtonFormField<String>(
                          elevation: 100,
                          dropdownColor: Constants.WHITE3,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(1.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          alignment: AlignmentDirectional.center,
                          hint: _dropDownValue == ""
                              ? Text(' Tipo de Licencia',
                                  style: TextStyle(fontWeight: FontWeight.bold))
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
                      )
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
                        return 'No puede dejar este casillero vacío';
                      }
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
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
                        return 'No puede dejar este casillero vacío\nEjemplo: ABC1234';
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
                        return 'No puede dejar este casillero vacío\nIngrese el Nombre y Apellido\nEjemplo: Christian Novoa';
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
                            borderRadius: BorderRadius.circular(15.0)),
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
                        widget.motocycle.vehicle!.expiryLicense = _newDate;
                      },
                      child: Text(
                        '${expiryLicense?.day}-${expiryLicense?.month}-${expiryLicense?.year}',
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ]))));
  }

  Future<void> _sendToServer() async {
    widget.motocycle.address = address.text;
    widget.motocycle.age = age.text;
    widget.motocycle.id = docId.text;
    widget.motocycle.name = name.text;
    widget.motocycle.nationality =
        countryValue != '' ? countryValue : nationality_temp;
    widget.motocycle.phone = phone.text;
    widget.motocycle.surname = surname.text;
    widget.motocycle.vehicle!.brand = brand.text;
    widget.motocycle.vehicle!.licence = license.text;
    widget.motocycle.vehicle!.model = model.text;
    widget.motocycle.vehicle!.plate = plate.text;
    widget.motocycle.vehicle!.numberRegister = numberRegist.text;
    widget.motocycle.vehicle!.owner = owner.text;
    widget.motocycle.vehicle!.typeLicense = _dropDownValue;
    widget.motocycle.vehicle!.expiryLicense = expiryLicense;
    widget.motocycle.urlimage = urlImagen;
    FirebaseFirestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference =
          FirebaseFirestore.instance.collection("usuario");
      QuerySnapshot pd = await reference.get();
      String docUid = "";
      for (var doc in pd.docs) {
        if (widget.motocycle.uid == doc.get("uid").toString()) {
          docUid = doc.id;
          break;
        }
      }
      await reference.doc(docUid).update(widget.motocycle.toJson());
    });
  }
}
