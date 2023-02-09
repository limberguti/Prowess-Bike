import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:prowess_app/models/motocycleModel.dart';
import 'package:prowess_app/models/pedidoModel.dart';
import 'package:prowess_app/services/pedidosService.dart';
import 'package:prowess_app/utils/constants.dart' as Constants;
import 'package:prowess_app/widgets/Card/orderCard.dart';
import 'package:location/location.dart';

import '../provider/main_provider.dart';
import 'dart:developer' as dev;




class OrderPenMot extends StatefulWidget {
  const OrderPenMot({Key? key, required this.motocycle, required this.pendiente})
      : super(key: key);
  final String motocycle;
  final bool pendiente;
  @override
  State<OrderPenMot> createState() => _OrderMotState();
}

class _OrderMotState extends State<OrderPenMot> {
  Location location = Location();
  LocationData? _locationData;
  bool _isGetLocation = false;
  String cityName = "";
  String name = "";
  PedidosService? _pedidiosService;

  _OrderMotState() {
    this._pedidiosService = new PedidosService();
    this._pedidoStream = this._pedidiosService?.getPedidosLibres();
    this._anterioresStream = this._pedidiosService?.getPedidosPendientes();
    
  }

   late final Stream<QuerySnapshot>? _pedidoStream;

  late final Stream<QuerySnapshot>? _anterioresStream;

  requestCurrentUbi() async { setState(() {
      dev.log(_locationData.toString(), name: "location");
      dev.log(cityName);
      _isGetLocation = true;
    });
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


    return Scaffold(
        backgroundColor: Constants.WHITE,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Constants.WHITE,
          ),
          title: Text('Pedidos Pendientes',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Constants.WHITE)),
          //actions
          shadowColor: Constants.VINTAGE,
          backgroundColor: Constants.VINTAGE,
        ),
        body: Container(
          
          height: MediaQuery.of(context).size.height *
                                  (MediaQuery.of(context).size.height * 1.1) /
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
                                                        horizontal: 70.0),
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
                                                  pedido: anteriores [index - 1],
                                                  pendiente: false);
                                            } else {
                                              return Container();
                                            }
                                          }
                                        }
                                      ),
                                    );
                                  })));
  setState(() {});
  });
}
}
