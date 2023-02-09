// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:prowess_app/models/motocycleModel.dart';
import 'package:prowess_app/models/pedidoModel.dart';
import 'package:prowess_app/services/ordersMoto.dart';
import 'package:prowess_app/services/pedidosService.dart';
import 'package:prowess_app/utils/constants.dart';
import 'package:prowess_app/utils/constants.dart' as Constants;
import 'package:prowess_app/widgets/Card/orderCard.dart';
import 'dart:developer' as dev;

final FirebaseAuth _auth = FirebaseAuth.instance;

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key, required this.motocycle}) : super(key: key);
  final Motocycle motocycle;

  @override
  _OrderPagetState createState() => _OrderPagetState();
}

bool _expanded1 = true;
bool _expanded2 = false;

class _OrderPagetState extends State<OrderPage> {
  Location location = Location();
  bool? _serviceEnabled;
  bool _isGetLocation = false;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  String cityName = "";
  String name = "";

  PedidosService? _pedidiosService;

  _OrderPagetState() {
    this._pedidiosService = new PedidosService();
    this._pedidoStream = this._pedidiosService?.getPedidosLibres();
    this._anterioresStream = this._pedidiosService?.getPedidosAnteriores();
  }

  late final Stream<QuerySnapshot>? _pedidoStream;

  late final Stream<QuerySnapshot>? _anterioresStream;

  requestCurrentUbi() async {
    //PREGUNTO SI EL SERVICIO ESTA DISPONIBLE
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (_serviceEnabled!) return;
    }

    //PREGUNTO SI SE TIENE PERMISOS PARA ACCEDER A LA UBICACION
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) return;
    }

    //AQUI OBTENGO MI DIRECCION ACTUAL SI CONCEDI LOS PERMISOS AL DISPOSITIVO
    _locationData = await location.getLocation();

    setState(() {
      dev.log(_locationData.toString(), name: "location");
      dev.log(cityName);
      _isGetLocation = true;
    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  int distanceAround = 100;

  final ScrollController scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    requestCurrentUbi();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _pedidoStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            const Center(
              child: Center(child: Text("Error al consultar los pedidos")),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: CircularProgressIndicator()),
            );
          }
          final List<Pedido> pedidos = snapshot.data!.docs
              .map((doc) => Pedido.fromJson(doc.data() as Map<String, dynamic>))
              .toList();
          final List id = snapshot.data!.docs.map((doc) => doc.id).toList();

          for (int i = 0; i < pedidos.length; i++) {
            pedidos[i].documentId = id[i];
          }

          return Column(children: [
            Flexible(
              child: ListView(children: [
                Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                      left: 0.0,
                      right: 0.0,
                      bottom: 0.0,
                    ),
                    child: ListTile(
                        title: Text(
                            '¡Bienvenid@\t' +
                                widget.motocycle
                                    .name! /*+ widget.motocycle.surname!*/ +
                                "!",
                            style: TextStyle(
                                color: Constants.VINTAGE,
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                        subtitle: Text(_auth.currentUser!.email ?? "",
                            style: TextStyle(
                                color: Color.fromRGBO(1, 20, 24, 31),
                                fontSize: 17)))),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ExpansionPanelList(
                      children: [
                        ExpansionPanel(
                            canTapOnHeader: true,
                            isExpanded: _expanded1,
                            headerBuilder:
                                (BuildContext context, bool isExpanded) {
                              return ListTile(
                                  title: Text("Pedidos libres de hoy"),
                                  subtitle: Text(
                                      "Aquí se muestra los pedidos libres para este dia"));
                            },
                            body: Container(
                              height: MediaQuery.of(context).size.height *
                                  (MediaQuery.of(context).size.height * 0.83) /
                                  820.57,
                              child: snapshot.data!.docs.isEmpty
                                  ? const Center(
                                      child: SizedBox(
                                          height: 100.0,
                                          width: 200.0,
                                          child: Text(
                                            "Aun no hay pedidos libres",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 20.0,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    )
                                  : MediaQuery.removePadding(
                                      context: context,
                                      removeTop: true,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        controller: scroll,
                                        itemCount: pedidos.length + 1,
                                        itemBuilder: (context, index) {
                                          if (index == 0) {
                                            return Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 50.0),
                                               
                                              ),
                                            );
                                          } else {
                                            late double dist = 0;
                                            if (_locationData != null) {
                                              dist = calculateDistance(
                                                  _locationData!.latitude,
                                                  _locationData!.longitude,
                                                  double.parse(
                                                      pedidos[index - 1]
                                                          .vendedor!
                                                          .lat!),
                                                  double.parse(
                                                      pedidos[index - 1]
                                                          .vendedor!
                                                          .long!));
                                            }
                                            if (dist < distanceAround) {
                                              return OrderCard(
                                                  pedido: pedidos[index - 1],
                                                  pendiente: false);
                                            } else {
                                              return Container();
                                            }
                                          }
                                        },
                                      ),
                                    ),
                            ))
                      ],
                      expansionCallback: (panelIndex, isExpanded) {
                        _expanded2 = false;
                        _expanded1 = !_expanded1;

                        setState(() {});
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: ExpansionPanelList(
                      children: [
                        ExpansionPanel(
                          canTapOnHeader: true,
                          isExpanded: _expanded2,
                          headerBuilder:
                              (BuildContext context, bool isExpanded) {
                            return ListTile(
                                title: Text("Pedidos anteriores"),
                                subtitle: Text(
                                    "Aquí se muestra los pedidos anteriores"));
                          },
                          body: Container(
                              height: MediaQuery.of(context).size.height *
                                  (MediaQuery.of(context).size.height * 0.63) /
                                  820.57,
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: _anterioresStream,
                                  builder: (context, snapshot2) {
                                    if (snapshot2.hasError) {
                                      const Center(
                                        child: Center(
                                            child: Text(
                                                "Error al consultar los pedidos")),
                                      );
                                    }
                                    if (snapshot2.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: SizedBox(
                                            height: 50.0,
                                            width: 50.0,
                                            child: CircularProgressIndicator()),
                                      );
                                    }
                                    final List<Pedido> anteriores = snapshot2
                                        .data!.docs
                                        .map((doc) => Pedido.fromJson(
                                            doc.data() as Map<String, dynamic>))
                                        .toList();
                                    final List id2 = snapshot2.data!.docs
                                        .map((doc) => doc.id)
                                        .toList();

                                    for (int i = 0;
                                        i < anteriores.length;
                                        i++) {
                                      anteriores[i].documentId = id2[i];
                                    }
                                    return MediaQuery.removePadding(
                                      removeBottom: true,
                                      context: context,
                                      removeTop: true,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        controller: scroll,
                                        itemCount: anteriores.length + 1,
                                        itemBuilder: (context, index) {
                                          if (index == 0) {
                                            return Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 50.0),
                                              ),
                                            );
                                          } else {
                                            late double dist = 0;
                                            if (_locationData != null) {
                                              dist = calculateDistance(
                                                  _locationData!.latitude,
                                                  _locationData!.longitude,
                                                  double.parse(
                                                      anteriores[index - 1]
                                                          .vendedor!
                                                          .lat!),
                                                  double.parse(
                                                      anteriores[index - 1]
                                                          .vendedor!
                                                          .long!));
                                            }
                                            if (dist < distanceAround) {
                                              return OrderCard(
                                                  pedido: anteriores[index - 1],
                                                  pendiente: false);
                                            } else {
                                              return Container();
                                            }
                                          }
                                        },
                                      ),
                                    );
                                  })),
                        )
                      ],
                      expansionCallback: (panelIndex, isExpanded) {
                        _expanded1 = false;
                        _expanded2 = !_expanded2;

                        setState(() {});
                      }),
                ),
              ]),
            )
          ]);
          /*return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Pedido model =
                Pedido.fromJson(document.data() as Map<String, dynamic>);
            model.documentId = document.id;
            return OrderCard(
              pedido: model,
              pendiente: false,
            );
          }).toList());*/
          /*Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Column(children: [
                Padding(padding: EdgeInsets.only(top: 100)),
                ExpansionTile(
                  initiallyExpanded: false,
                  title: Text("Pedidos del día"),
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final pedido = Pedido.fromJson(
                              snapshot.data!.docs[index],
                             );
                          return OrderCard(pedido: pedido);
                        }),
                  ],
                ),
              ]));*/

          //Expandable listview with the data from snapshot

          /*ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                Pedido model =
                    Pedido.fromJson(document.data() as Map<String, dynamic>);
                model.documentId = document.id;
                return OrderCard(                 pedido: model,
                  pendiente: false,)
                );
              }).toList()),
          ]);*/
        });
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("5 km"), value: "5"),
      DropdownMenuItem(child: Text("25 km"), value: "25"),
      DropdownMenuItem(child: Text("50 km"), value: "50"),
      DropdownMenuItem(child: Text("100 km"), value: "100"),
    ];
    return menuItems;
  }
}
