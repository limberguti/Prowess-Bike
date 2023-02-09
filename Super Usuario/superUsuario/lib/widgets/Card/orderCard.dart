import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prowess_app/components/orderCardComponent.dart';
import 'package:prowess_app/models/pedidoModel.dart';
import 'package:prowess_app/pages/mapPage.dart';
import 'package:prowess_app/pages/orderInfPage.dart';
import 'package:prowess_app/utils/constants.dart' as Constants;
import 'dart:developer' as dev;

class OrderCard extends StatefulWidget {
  const OrderCard({Key? key, required this.pedido, required this.pendiente})
      : super(key: key);
  final Pedido pedido;
  final bool pendiente;

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  @override
  void initState() {
    super.initState();

    dev.log("Getting distance");
    if (widget.pedido.comprador!.lat != null) {
      _getDistance().then((value) {
        setState(() {});
      });
    }
  }

  String distanceString = "";
  String priceString = "";
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    //ELIMINAR en cuanto se logre enviar estos datos directamente desde la API
    widget.pedido.distancia = distanceString;
    widget.pedido.precio = priceString;

    return OrderCardComponent(
      onTap: () {
        widget.pendiente
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => mapPage(
                    pedido: widget.pedido,
                    aceptacion: true,
                  ),
                ),
              )
            : widget.pedido.estado == "libre"
                ? widget.pedido.comprador!.lat == "" ||
                        widget.pedido.comprador!.long == ""
                    ? showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text(
                                  'Problemas con obtención de Coordenadas',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Constants.VINTAGE)),
                              content: Text(
                                  'Las Coordenadas del comprador se encuentran vacias'),
                              actions: <Widget>[
                                FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        Constants.BORDER_RADIOUS),
                                  ),
                                  color: Constants.VINTAGE,
                                  child: Text('Ok',
                                      style: TextStyle(color: Constants.WHITE)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ))
                    : widget.pedido.vendedor!.lat == "" ||
                            widget.pedido.vendedor!.long == ""
                        ? showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text(
                                      'Problemas con obtención de Coordenadas',
                                      textAlign: TextAlign.center,
                                      style:
                                          TextStyle(color: Constants.VINTAGE)),
                                  content: Text(
                                      'Las Coordenadas del vendedor se encuentran vacias'),
                                  actions: <Widget>[
                                    FlatButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              Constants.BORDER_RADIOUS)),
                                      color: Constants.VINTAGE,
                                      child: Text('Ok',
                                          style: TextStyle(
                                              color: Constants.WHITE)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ))
                        : priceString == ""
                            ? showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text(
                                        'Calculando precio de envio ...',
                                        textAlign: TextAlign.center,
                                        style:
                                            TextStyle(color: Constants.VINTAGE),
                                      ),
                                      actions: <Widget>[
                                        FlatButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                Constants.BORDER_RADIOUS),
                                          ),
                                          color: Constants.VINTAGE,
                                          child: Text(
                                            'Ok',
                                            style: TextStyle(
                                                color: Constants.WHITE),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ))
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderInfo(
                                    pedido: widget.pedido,
                                  ),
                                ),
                              )
                // ignore: unnecessary_statements
                : null;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25),
        decoration: BoxDecoration(
            color: Constants.WHITE,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(width: 2.0, color: Constants.VINTAGE)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Text(
                  "Pedido Nº " + widget.pedido.numPedido!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Constants.VINTAGE,
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Icon(Icons.person_outline, color: Constants.BLACK),
                Text(
                  widget.pedido.comprador!.nombre!,
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Constants.BLACK,
                    fontSize: 13.5,
                  ),
                ),
              ]),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, color: Constants.BLACK),
                  SizedBox(
                    width: size.width - 90,
                    child: Text(
                      widget.pedido.comprador!.dir1!,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Constants.BLACK,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(
            color: Constants.GRAY,
          ),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Constants.WHITE,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                        width: 1.0,
                        color: widget.pedido.estado == 'libre'
                            ? Colors.greenAccent
                            : widget.pedido.estado == 'en ruta'
                                ? Colors.blue
                                : widget.pedido.estado == "recogido"
                                    ? Colors.purpleAccent
                                    : widget.pedido.estado == "Entregado"
                                        ? Colors.lightGreen
                                        : Constants.GREEN),
                  ),
                  child: Row(
                    children: [
                      widget.pedido.estado == 'libre'
                          ? Text(
                              "\t" +
                                  widget.pedido.estado! +
                                  " - " +
                                  priceString +
                                  " \$",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 139, 195, 74),
                                fontSize: 15.0,
                              ),
                            )
                          : Text(
                              "\t" + widget.pedido.estado!,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 139, 195, 74),
                                fontSize: 15.0,
                              ),
                            ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  /* children: [
                    Icon(Icons.shopping_cart_outlined, color: Constants.BLACK),
                  ],
                  */
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      //"Pedido  " +
                      distanceString + " km Aprox.",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Constants.BLACK,
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  closeAction(BuildContext context) {
    Navigator.of(context).pop();
  }

  String subString(String nombre) {
    String str;
    try {
      str = nombre.substring(0, 15);
      return str;
    } catch (e) {
      print(e);
      return nombre;
    }
  }

  //ELIMINAR cuando se logre enviar estos datos directamente desde la API
  _getDistance() async {
    try {
      List<LatLng> polylineCoordinates = [];
      PolylinePoints polylinePoints = PolylinePoints();
      double distance = 0.0;
      dev.log(
          widget.pedido.vendedor!.long.toString() +
              " - " +
              widget.pedido.numPedido.toString(),
          name: "NUM");

      if (widget.pedido.vendedor!.long == "-78.18340599999999") {
        widget.pedido.vendedor!.long = "-78.48183";
        widget.pedido.vendedor!.lat = "-0.19776";
        dev.log(
            widget.pedido.vendedor!.long.toString() +
                " - " +
                widget.pedido.numPedido.toString(),
            name: "NUMCAMBIADO");
      }
      dev.log(widget.pedido.comprador!.lat.toString(), name: "LAT");
      dev.log(widget.pedido.comprador!.long.toString(), name: "LNG");
      PointLatLng dato1 = PointLatLng(
          double.parse(widget.pedido.comprador!.lat!),
          double.parse(widget.pedido.comprador!.long!));
      PointLatLng dato2 = PointLatLng(
          double.parse(widget.pedido.vendedor!.lat!),
          double.parse(widget.pedido.vendedor!.long!));
      dev.log(dato1.toString(), name: "DATO1");
      dev.log(dato2.toString(), name: "DATO2");
      String googleAPIKey = 'AIzaSyCavjeXj89kGr11VqrxSWHKYBkU-Ms-Iv8';
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPIKey,
        dato1,
        dato2,
        travelMode: TravelMode.driving,
      );
      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      } else {
        print(result.errorMessage);
      }
      double totalDistance = 0;
      for (var i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += calculateDistance(
            polylineCoordinates[i].latitude,
            polylineCoordinates[i].longitude,
            polylineCoordinates[i + 1].latitude,
            polylineCoordinates[i + 1].longitude);
      }
      if (totalDistance > 0) {
        dev.log(totalDistance.toString(), name: "totalDistance");
        dev.log(totalDistance.toStringAsFixed(2), name: "totalDistance");
        //priceString = ((totalDistance * 32*0.65)/100).toStringAsFixed(2);

        double precio = ((totalDistance * 0.30));
        priceString = costoEnvio(precio).toString();

        distanceString = totalDistance.toStringAsFixed(2);
      }

      setState(() {
        dev.log(distanceString, name: "distanceString");
      });
    } catch (e) {
      dev.log(e.toString());
    }
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  //Redondeo del costo de envio
  double costoEnvio(double precio) {
    double aux = 0.00;
    double precioEnvio = 0.00;

    aux = precio - precio.truncate();

    if (aux <= 0.25 && aux >= 0.01) {
      precioEnvio = precio.truncate() + 0.0;
    } else {
      if (aux > 0.25 && aux <= 0.50 || aux > 0.50 && aux < 0.75) {
        precioEnvio = precio.truncate() + 0.5;
      } else {
        if (aux >= 0.75 && aux <= 0.99) {
          precioEnvio = precio.truncate() + 1.00;
        }
      }
    }

    return precioEnvio;
  }
}
