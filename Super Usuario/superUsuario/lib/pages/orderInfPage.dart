import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:prowess_app/components/titleComponent.dart';
import 'package:prowess_app/models/pedidoModel.dart';
import 'package:prowess_app/pages/mapPage.dart';
import 'package:prowess_app/utils/constants.dart' as Constants;
import 'package:intl/intl.dart';
import 'package:prowess_app/widgets/Card/detalleCard.dart';
import 'package:prowess_app/widgets/Card/orderCard.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:prowess_app/services/pedidosService.dart';
import '../models/motocycleModel.dart';
import '../provider/main_provider.dart';

class OrderInfo extends StatefulWidget {
  OrderInfo({Key? key, required this.pedido}) : super(key: key);
  final Pedido pedido;

  @override
  State<OrderInfo> createState() => _OrderInfoState();
}


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

class _OrderInfoState extends State<OrderInfo> {
  PedidosService actualizarPedido = PedidosService();

  int _currentStep = 0;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  DateFormat timeFormat = DateFormat("HH:mm:ss");
  @override
  Widget build(BuildContext context) {
    
    final mainProvider = Provider.of<MainProvider>(context);
    
    Motocycle motocycleObject = new Motocycle.fromJson(
        json.decode(mainProvider.motocycle) as Map<String, dynamic>);
        
    
    return Scaffold(
      
      appBar: AppBar(
          iconTheme: IconThemeData(
            color: Constants.WHITE,
          ),
          centerTitle: true,
          backgroundColor: Constants.VINTAGE,
          title: Text("Información del Pedido",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold))),
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
            physics: ScrollPhysics(),
            currentStep: _currentStep,
            onStepContinue: () {
              // ignore: unnecessary_statements
              _currentStep < 2 ? setState(() => _currentStep += 1) : null;
            },
            onStepCancel: () {
              // ignore: unnecessary_statements
              _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
            },
            type: StepperType.horizontal,
            steps: <Step>[
              //COMPRADOR
              Step(
                title: Icon(
                  Icons.add_business_outlined,
                  color: Colors.grey,
                ),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Pedido Nº ' + widget.pedido.numPedido!,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Comprador",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 23.04,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 9.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50.0),
                          border: Border.all(width: 1.0, color: Colors.white)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.calendar_today),
                                    Text(
                                        dateFormat.format(widget.pedido.fecha!),
                                        style: TextStyle(
                                            color: Constants.GRAY,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.normal)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.timer_sharp),
                                    Text(
                                        timeFormat.format(widget.pedido.fecha!),
                                        style: TextStyle(
                                            color: Constants.GRAY,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.normal)),
                                  ],
                                ),
                              ],
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 115.0, vertical: 9.0),
                      decoration: BoxDecoration(
                          color: Constants.WHITE,
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(width: 2.0, color: Colors.white)),
                      child: Column(
                        children: [
                          Text(
                            "Nombre:\n",
                            style: TextStyle(
                                color: Constants.BLACK,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "\t\t" + widget.pedido.comprador!.nombre!,
                            style: TextStyle(
                                color: Constants.GRAY,
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Ciudad:",
                            style: TextStyle(
                                color: Constants.BLACK,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "\t\t" + widget.pedido.comprador!.ciudad!,
                            style: TextStyle(
                                color: Constants.GRAY,
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Teléfono:",
                            style: TextStyle(
                                color: Constants.BLACK,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                            onPressed: () {
                              _makingPhoneCall(widget.pedido.comprador!.phone!);
                            },
                            child: Text(
                              widget.pedido.comprador!.phone!,
                              style: TextStyle(
                                  color: Constants.GRAY,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text(
                            "Dirección:",
                            style: TextStyle(
                                color: Constants.BLACK,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "\t\t" + widget.pedido.comprador!.dir1!,
                            style: TextStyle(
                                color: Constants.GRAY,
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Referencia:",
                            style: TextStyle(
                                color: Constants.BLACK,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "\t\t" + widget.pedido.comprador!.dir2!,
                            style: TextStyle(
                                color: Constants.GRAY,
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                isActive: _currentStep >= 0,
                state:
                    _currentStep >= 0 ? StepState.complete : StepState.disabled,
              ),
              //VENDEDOR
              Step(
                title: Icon(Icons.person, color: Colors.grey),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Pedido Nº ' + widget.pedido.numPedido!,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Vendedor",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 9.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50.0),
                          border: Border.all(width: 1.0, color: Colors.white)),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.calendar_today),
                                    Text(
                                        dateFormat.format(widget.pedido.fecha!),
                                        style: TextStyle(
                                            color: Constants.GRAY,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.normal)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.timer_sharp),
                                    Text(
                                        timeFormat.format(widget.pedido.fecha!),
                                        style: TextStyle(
                                            color: Constants.GRAY,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.normal)),
                                  ],
                                ),
                              ],
                            ),
                          ]),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10),
                      decoration: BoxDecoration(
                          color: Constants.WHITE,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(width: 2.0, color: Colors.white)),
                      child: Column(
                        children: [
                          Text(
                            "Nombre:",
                            style: TextStyle(
                                color: Constants.BLACK,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "\t\t" + widget.pedido.vendedor!.nombre!,
                            style: TextStyle(
                                color: Constants.GRAY,
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Nombre de la tienda:",
                            style: TextStyle(
                                color: Constants.BLACK,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "\t\t" + widget.pedido.vendedor!.nombreTienda!,
                            style: TextStyle(
                                color: Constants.GRAY,
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Ciudad:",
                            style: TextStyle(
                                color: Constants.BLACK,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "\t\t" + widget.pedido.vendedor!.ciudad!,
                            style: TextStyle(
                                color: Constants.GRAY,
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Teléfono:",
                            style: TextStyle(
                                color: Constants.BLACK,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          TextButton(
                            onPressed: () {
                              _makingPhoneCall(widget.pedido.vendedor!.phone!);
                            },
                            child: Text(
                              widget.pedido.vendedor!.phone!,
                              style: TextStyle(
                                  color: Constants.GRAY,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text(
                            "Dirección:",
                            style: TextStyle(
                                color: Constants.BLACK,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Calle 1 -> " + widget.pedido.vendedor!.calle1!,
                                style: TextStyle(
                                    color: Constants.GRAY,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.normal),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "Calle 2 -> " + widget.pedido.vendedor!.calle2!,
                                style: TextStyle(
                                    color: Constants.GRAY,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.normal),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "URL:",
                            style: TextStyle(
                                color: Constants.BLACK,
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "\t\t" + widget.pedido.vendedor!.url!,
                            style: TextStyle(
                                color: Constants.BLACK,
                                fontSize: 15.0,
                                fontWeight: FontWeight.normal),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                isActive: _currentStep >= 1,
                state:
                    _currentStep >= 1 ? StepState.complete : StepState.disabled,
              ),
              //DETALLE Y PAGO
              Step(
                title: Icon(Icons.shopping_cart_outlined, color: Colors.grey),
                content: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Pedido Nº ' + widget.pedido.numPedido!,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text("Detalle",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 23.04,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 9.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50.0),
                          border: Border.all(width: 1.0, color: Colors.white)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.calendar_today),
                                  Text(dateFormat.format(widget.pedido.fecha!),
                                      style: TextStyle(
                                          color: Constants.GRAY,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.normal)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.timer_sharp),
                                  Text(timeFormat.format(widget.pedido.fecha!),
                                      style: TextStyle(
                                          color: Constants.GRAY,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.normal)),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Producto",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    //card por cada detalle
                    Column(
                      children: widget.pedido.detalle!
                          .map((e) => DetalleCard(model: e))
                          .toList(),
                    ),

                    //pago
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Tipo de envío:",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 35.0),
                        decoration: BoxDecoration(
                            color: Constants.WHITE,
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(
                                width: 2.0,
                                color: Color.fromARGB(255, 248, 247, 246))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(widget.pedido.pago!.tipoDePago!,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    "Costo de Envío:    " +
                                        "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t" +
                                        widget.pedido.pago!.monedaSymbol! +
                                        widget.pedido.precio.toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Divider(
                              color: Constants.GRAY,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "Total:" +
                                        "\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t" +
                                        widget.pedido.pago!.monedaSymbol! +
                                        (double.parse(widget
                                                    .pedido.pago!.total!) +
                                                double.parse(widget
                                                    .pedido.precio
                                                    .toString()))
                                            .toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 23.0,
                                        fontWeight: FontWeight.w900)),
                              ],
                            ),
                          ],
                        )),
                    ElevatedButton(
                      onPressed: () => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('¿Desea aceptar este pedido?'),
                          content: Text(
                            'Pedido Nº ' + widget.pedido.numPedido!,
                            style: TextStyle(
                                color: Constants.BLACK,
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal),
                            textAlign: TextAlign.center,
                          ),
                          actions: <Widget>[
                            TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                style: ElevatedButton.styleFrom(
                                  side: BorderSide(color: Constants.VINTAGE),
                                  fixedSize: Size(140, 40),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                ),
                                child: const Text('Cancelar',
                                    style: TextStyle(
                                        color: Constants.VINTAGE,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold))),
                            TextButton(
                              onPressed: () async {
                                mainProvider.pendientes = true;

                                bool estado =
                                    await actualizarPedido.comprobarPedido(
                                        widget.pedido.documentId ?? "");
                                // orderList. _loadStore(widget.pedido.documentId);
                                if (estado) {
                                  actualizarPedido.acceptPedidos(
                                      widget.pedido.documentId ?? '',
                                      "en proceso",
                                      motocycleObject.uid.toString());

                                  return showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Pedido aceptado',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 23.04,
                                                  fontWeight: FontWeight.bold)),
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
                                                  'Exitoso',
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            Container(
                                              child: Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: TextButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      fixedSize: Size(100, 40),
                                                      primary:
                                                          Constants.VINTAGE,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0)),
                                                    ),
                                                    child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text('Aceptar',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 16.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold))),
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      mapPage(
                                                                        pedido:
                                                                            widget.pedido,
                                                                        aceptacion:
                                                                            false,
                                                                      )));
                                                    }),
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(140, 40),
                                primary: Constants.VINTAGE,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                              ),
                              child: const Text('Sí',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(40),
                        primary: Constants.VINTAGE,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                      ),
                      child: const Text("Aceptar",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                isActive: _currentStep >= 2,
                state:
                    _currentStep >= 2 ? StepState.complete : StepState.disabled,
              )
            ]),
      ),
    );

  }

  closeAction(BuildContext context) {
    Navigator.of(context).pop();
  }

  _makingPhoneCall(String phone) async {
    final Uri url = Uri(scheme: 'tel', path: phone);
    await launch(url.toString());
  }
}
