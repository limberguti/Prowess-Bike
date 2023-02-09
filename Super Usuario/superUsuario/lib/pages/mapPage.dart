import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:prowess_app/models/pedidoModel.dart';
import 'package:prowess_app/pages/detailsPage.dart';
import 'package:location/location.dart';
import 'package:prowess_app/services/directions_model.dart';
import 'package:prowess_app/services/directions_repository.dart';
import 'package:prowess_app/services/ordersMoto.dart';
import 'package:prowess_app/utils/constants.dart' as Constants;

// ignore: camel_case_types
class mapPage extends StatefulWidget {
  const mapPage({Key? key, required this.pedido, required this.aceptacion})
      : super(key: key);
  final Pedido pedido;
  final bool aceptacion;

  @override
  State<mapPage> createState() => _MapPageState();
}

class _MapPageState extends State<mapPage> {
  // ignore: unused_field
  OrdersMoto _service = OrdersMoto();

  Set<Marker> _markers = Set<Marker>();

  Completer<GoogleMapController> _controller = Completer();
  Marker _motorized = new Marker(markerId: MarkerId('motorizado'));
  Marker _buyer = new Marker(markerId: MarkerId('comprador'));
  Marker _seller = new Marker(markerId: MarkerId('vendedor'));

  PolylinePoints polylinePoints = new PolylinePoints();
  List<PointLatLng> polPoints = [];
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  Directions? _info = new Directions(
      bounds: LatLngBounds(northeast: LatLng(0, 0), southwest: LatLng(0, 0)),
      polylinePoints: PolylinePoints().decodePolyline(""),
      totalDistance: '',
      totalDuration: '');
  Directions? _info2 = new Directions(
      bounds: LatLngBounds(northeast: LatLng(0, 0), southwest: LatLng(0, 0)),
      polylinePoints: PolylinePoints().decodePolyline(""),
      totalDistance: '',
      totalDuration: '');

  //PERMISOS LOCACION
  Location location = Location();
  bool? _serviceEnabled;
  bool _isGetLocation = false;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  //var distancia = "";
  @override
  void initState() {
    super.initState();
    print("inicio del Estado");
    requestCurrentUbi();
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return widget.aceptacion;
      },
      child: Scaffold(
          appBar: AppBar(
              iconTheme: IconThemeData(
                color: Constants.WHITE,
              ),
              centerTitle: true,
              backgroundColor: Constants.VINTAGE,
              title: Text("Información",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold))),
          body: Stack(
            alignment: Alignment.center,
            children: [
              _isGetLocation
                  ? GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: new CameraPosition(
                        target: LatLng(_locationData!.latitude!,
                            _locationData!.longitude!),
                        zoom: 18.5,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);

                        var motorizado = LatLng(_locationData!.latitude!,
                            _locationData!.longitude!);
                        var vendedor = LatLng(
                            double.parse(widget.pedido.vendedor!.lat ?? ""),
                            double.parse(widget.pedido.vendedor!.long ?? ""));
                        var comprador = LatLng(
                            double.parse(widget.pedido.comprador!.lat ?? ""),
                            double.parse(widget.pedido.comprador!.long ?? ""));
                        _addMarkers(motorizado, vendedor, comprador);
                      },
                      //markers: _markers,
                      markers: {
                          this._motorized,
                          this._buyer,
                          this._seller,
                        },
                      polylines: {
                          Polyline(
                            polylineId: const PolylineId('overview_polyline'),
                            color: Colors.red,
                            width: 5,
                            points: _info!.polylinePoints
                                .map((e) => LatLng(e.latitude, e.longitude))
                                .toList(),
                          ),
                          Polyline(
                            polylineId: const PolylineId('polilinea 2'),
                            color: Colors.orange,
                            width: 5,
                            points: _info2!.polylinePoints
                                .map((e) => LatLng(e.latitude, e.longitude))
                                .toList(),
                          ),
                        })
                  : CircularProgressIndicator(),
              Positioned(
                bottom: 20,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 95.0,
                  ),
                  child: FloatingActionButton.extended(
                    backgroundColor: Constants.VINTAGE,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailsPage(
                                    pedidos: widget.pedido,
                                  )));
                    },
                    label: const Text(
                      "Estado del Pedido",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                    icon: Icon(Icons.layers_outlined, color: Colors.white),
                  ),
                ),
              ),
              Positioned(
                bottom: 100,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15.0,
                    horizontal: 95.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 2),
                        blurRadius: 6.0,
                      )
                    ],
                  ),
                  child: Text(
                    "Distancia de llegada: \n" +
                        widget.pedido.distancia.toString() +
                        "Km - " +
                        widget.pedido.precio.toString() +
                        "\$",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Future<void> _addMarkers(
      LatLng motorized, LatLng seller, LatLng buyer) async {
    await _controller.future;
    setState(() {
      _motorized = Marker(
        markerId: const MarkerId("Motorizado"),
        infoWindow: const InfoWindow(title: 'Motorizado'),
        position: motorized,
      );
      // ignore: unnecessary_statements

      _seller = Marker(
        markerId: const MarkerId("Vendedor"),
        infoWindow: const InfoWindow(title: 'Vendedor'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        position: seller,
      );

      _buyer = Marker(
        markerId: const MarkerId("Comprador"),
        infoWindow: const InfoWindow(title: 'Comprador'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        position: buyer,
      );
    });

    final directions = await DirectionsRepository().getDirections(
        origin: _motorized.position, destination: _seller.position);
    setState(() => _info2 = directions);
    final directions2 = await DirectionsRepository()
        .getDirections(origin: _seller.position, destination: _buyer.position);

    setState(() => _info = directions2);
  }

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
      _isGetLocation = true;
      _markers.add(Marker(
        markerId: MarkerId('Ubicacion Motorizado'),
        position: LatLng(_locationData!.latitude!, _locationData!.longitude!),
      ));
    });
  }
}
