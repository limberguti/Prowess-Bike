import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:prowess_app/models/pedidoModel.dart';
import 'package:prowess_app/pages/mainPage.dart';
import 'package:prowess_app/services/pedidosService.dart';
import 'package:prowess_app/services/userService.dart';
import 'package:prowess_app/widgets/Card/detalleCard.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:prowess_app/utils/constants.dart' as Constants;
import 'dart:developer' as dev;
import '../provider/main_provider.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key, required this.pedidos}) : super(key: key);
  final Pedido pedidos;

  @override
  DetailsPageState createState() => DetailsPageState();
}

class DetailsPageState extends State<DetailsPage> {
  PedidosService actualizarPedido = PedidosService();
  UserService userService = UserService();

  void launcherWhatsapp(String number, String message) async {
    String url = 'whatsapp://send?phone=$number&text=$message';
    await canLaunch(url)
        ? launch(url)
        : print(
            'Lo sentimos, hubo un problema al abrir la aplicación Whatsapp');
  }

  _makingPhoneCall(String phone) async {
    final Uri url = Uri(scheme: 'tel', path: phone);
    await launch(url.toString());
  }

  String name = "";

  @override
  Widget build(BuildContext context) {
    final mainProvider = Provider.of<MainProvider>(context);
    var _pedido = FirebaseFirestore.instance
        .collection("pedidos")
        .doc(widget.pedidos.documentId)
        .get()
        .asStream();
    final Size size = MediaQuery.of(context).size;

    //Cargar los nombres de los motorizados
    userService
        .recuperarNameMotorizado(widget.pedidos.uidmot!)
        .then((value) => name = value);
    return Scaffold(
      backgroundColor: Constants.VINTAGE,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Constants.WHITE,
        ),
        title: Text(
          'Detalles del pedido',
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        //shadowColor: Constants.VINTAGE,
        backgroundColor: Constants.VINTAGE,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: _pedido,
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
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
            //cambio a pedido
            Pedido pedido =
                Pedido.fromJson(snapshot.data!.data() as Map<String, dynamic>);
            pedido.documentId = widget.pedidos.documentId;
            return SingleChildScrollView(
              child:
                  Stack(alignment: AlignmentDirectional.topCenter, children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    //imagen de fondo
                    image: DecorationImage(
                        image: AssetImage('assets/images/Motorcycle_bg.png'),
                        fit: BoxFit.cover),
                    color: Constants.WHITE,
                    /* borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)), */
                  ),
                  child: Column(children: [
                    //CHAT CON EL CLIENTE
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        "¿Cuál es el estado del Pedido?",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Pedido Nº " + pedido.numPedido!,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Text(
                        "Estado: " + pedido.estado!.toUpperCase(),
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      /*decoration: BoxDecoration(
                        color: Constants.WHITE,
                        border: Border.all(
                            width: 2.0,
                            color: Color.fromARGB(255, 226, 225, 225)),
                        borderRadius: BorderRadius.circular(15),
                      ),*/
                      padding: EdgeInsets.all(10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Detalle",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600),
                            ),
                            Column(
                              children: pedido.detalle!
                                  .map((e) => DetalleCard(model: e))
                                  .toList(),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            /*Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Tipo de Pago",
                                        style: GoogleFonts.robotoSlab(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 13)),
                                    Text(pedido.pago!.tipoDePago!,
                                        style: GoogleFonts.robotoSlab(
                                            color: Colors.black, fontSize: 15)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text("Envío",
                                        style: GoogleFonts.robotoSlab(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 13)),
                                    Text(
                                        pedido.pago!.monedaSymbol! +
                                            widget.pedidos.precio.toString(),
                                        style: GoogleFonts.robotoSlab(
                                            color: Colors.black, fontSize: 15)),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text("Total",
                                        style: GoogleFonts.robotoSlab(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 15)),
                                    Text(
                                        pedido.pago!.monedaSymbol! +
                                            (double.parse(widget
                                                        .pedidos.pago!.total!) +
                                                    double.parse(widget
                                                        .pedidos.precio
                                                        .toString()))
                                                .toString(),
                                        style: GoogleFonts.robotoSlab(
                                            color: Constants.VINTAGE,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ],
                            )*/
                          ]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Pedido recogido
                        SizedBox(width: 10.0),
                        FloatingActionButton.extended(
                          heroTag: " boton1",
                          backgroundColor: pedido.estado == 'en proceso'
                              ? Constants.VINTAGE
                              : Constants.WHITE,
                          label: Text(
                            'Recogido',
                            style: TextStyle(
                                color: pedido.estado == 'en proceso'
                                    ? Constants.WHITE
                                    : Constants.BLACK),
                          ),
                          onPressed: pedido.estado == 'en proceso'
                              ? () => showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text(
                                          '¿Desea cambiar el estado a Recogido?',
                                          textAlign: TextAlign.center),
                                      content: Text(
                                        'Pedido Nº ' + pedido.numPedido!,
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
                                            side: BorderSide(
                                                color: Constants.VINTAGE),
                                            fixedSize: Size(140, 40),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.0)),
                                          ),
                                          child: const Text(
                                            'Cancelar',
                                            style: TextStyle(
                                                color: Constants.VINTAGE,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            actualizarPedido.updatePedidos(
                                                pedido.documentId ?? '',
                                                "recogido");
                                            await launch(
                                                "https://wa.me/593${pedido.comprador!.phone!}?text=¡Hola mucho gusto 😊! Soy ${name} su motorizado del pedido ${pedido.numPedido!}, su pedido ha sido *¡¡Recogido Exitosamente!!*");
                                            setState(() {
                                              Navigator.pop(context);
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary: Constants.VINTAGE,
                                            side: BorderSide(
                                                color: Constants.VINTAGE),
                                            fixedSize: Size(140, 40),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.0)),
                                          ),
                                          child: const Text(
                                            'Aceptar',
                                            style: TextStyle(
                                                color: Constants.WHITE,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                    ),
                                  )
                              : null,
                        ),
                        //Pedido en ruta

                        SizedBox(width: 10.0),
                        FloatingActionButton.extended(
                          heroTag: " boton4",
                          backgroundColor: pedido.estado == 'recogido'
                              ? Constants.VINTAGE
                              : Constants.WHITE,
                          label: Text(
                            'En Ruta',
                            style: TextStyle(
                                color: pedido.estado == 'recogido'
                                    ? Constants.WHITE
                                    : Constants.BLACK),
                          ),
                          onPressed: pedido.estado == 'recogido'
                              ? () => showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text(
                                          '¿Desea cambiar el estado a En Ruta?',
                                          textAlign: TextAlign.center),
                                      content: Text(
                                        'Pedido Nº ' + pedido.numPedido!,
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
                                            side: BorderSide(
                                                color: Constants.VINTAGE),
                                            fixedSize: Size(140, 40),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.0)),
                                          ),
                                          child: const Text(
                                            'Cancelar',
                                            style: TextStyle(
                                                color: Constants.VINTAGE,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            actualizarPedido.updatePedidos(
                                                pedido.documentId ?? '',
                                                "en ruta");
                                            await launch(
                                                "https://wa.me/593${pedido.comprador!.phone!}?text=¡Hola mucho gusto 🏍! Soy ${name} su motorizado del pedido ${pedido.numPedido!}, su pedido se encuentra *¡¡En Ruta!!*");
                                            setState(() {
                                              Navigator.pop(context);
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary: Constants.VINTAGE,
                                            side: BorderSide(
                                                color: Constants.VINTAGE),
                                            fixedSize: Size(140, 40),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.0)),
                                          ),
                                          child: const Text(
                                            'Aceptar',
                                            style: TextStyle(
                                                color: Constants.WHITE,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                    ),
                                  )
                              : null,
                        ),
                        //Pedido entregado
                        SizedBox(width: 10.0),
                        FloatingActionButton.extended(
                          heroTag: " boton2",
                          backgroundColor: pedido.estado == 'en ruta'
                              ? Constants.VINTAGE
                              : Constants.WHITE,
                          label: Text(
                            'Entregado',
                            style: TextStyle(
                                color: pedido.estado == 'en ruta'
                                    ? Constants.WHITE
                                    : Constants.BLACK),
                          ),
                          onPressed: pedido.estado == 'en ruta'
                              ? () => showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text(
                                        '¿Desea cambiar el estado a Entregado?',
                                        textAlign: TextAlign.center,
                                      ),
                                      content: Text(
                                        'Pedido Nº ' + pedido.numPedido!,
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
                                            side: BorderSide(
                                                color: Constants.VINTAGE),
                                            fixedSize: Size(140, 40),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        15.0)),
                                          ),
                                          child: const Text(
                                            'Cancelar',
                                            style: TextStyle(
                                                color: Constants.VINTAGE,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            actualizarPedido.updatePedidos(
                                                pedido.documentId ?? '',
                                                "Entregado");
                                            await launch(
                                                "https://wa.me/593${pedido.comprador!.phone!}?text=¡Hola mucho gusto ✔! Soy ${name} su motorizado del pedido ${pedido.numPedido!}, su pedido ha sido *¡¡Entregado Exitosamente!!*");
                                            setState(() {
                                              mainProvider.pendientes = false;
                                              dev.log(
                                                  mainProvider.pendientes
                                                      .toString(),
                                                  name: "Estado pendiente");
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MainPage(
                                                          titulo: "",
                                                          motocycle:
                                                              mainProvider
                                                                  .motocycle),
                                                ),
                                              );
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary: Constants.VINTAGE,
                                            side: BorderSide(
                                                color: Constants.VINTAGE),
                                            fixedSize: Size(140, 40),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                            ),
                                          ),
                                          child: const Text(
                                            'Aceptar',
                                            style: TextStyle(
                                                color: Constants.WHITE,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                    ),
                                  )
                              : null,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),

                    //Comprador
                    Align(
                      alignment: Alignment(-0.9, 0.0),
                      child: Text(
                        "Comprador",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Constants.WHITE,
                          border: Border.all(
                              width: 2.0,
                              color: Color.fromARGB(255, 226, 225, 225)),
                          borderRadius: BorderRadius.circular(15)),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          IntrinsicHeight(
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    Icons.account_circle_outlined, //Nombre
                                    size: 30,
                                    color: Constants.WEDDING,
                                  ),
                                  VerticalDivider(
                                    color: Constants.WEDDING,
                                    thickness: 0.5,
                                    width: 25,
                                    indent: 9,
                                    endIndent: 9,
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      width: size.width - 200,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 1.0),
                                        child: Text(
                                          pedido.comprador!.nombre!,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async => await launch(
                                        "https://wa.me/593${pedido.comprador!.phone!}?text=¡Hola mucho gusto 😊! Soy ${name} su motorizado del pedido ${pedido.numPedido!}, su pedido se encuentra *¡¡En Ruta!!*"),
                                    icon: Icon(
                                      Icons.chat_bubble_outline,
                                      size: 30,
                                      color: Constants.WEDDING,
                                    ),
                                  ),
                                ]),
                          ),
                          Divider(
                            color: Constants.WEDDING,
                            thickness: 0.5,
                            height: 1,
                            endIndent: 50,
                          ),
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.language_outlined, //Ciudad
                                  size: 30,
                                  color: Constants.WEDDING,
                                ),
                                VerticalDivider(
                                  color: Constants.WEDDING,
                                  thickness: 0.5,
                                  width: 25,
                                  indent: 9,
                                  endIndent: 9,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 1.0),
                                    child: Text(
                                      pedido.comprador!.ciudad!,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _makingPhoneCall(pedido.comprador!.phone!);
                                  },
                                  icon: Icon(
                                    Icons.phone_outlined,
                                    size: 30,
                                    color: Constants.WEDDING,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Constants.WEDDING,
                            thickness: 0.5,
                            height: 1,
                            endIndent: 50,
                          ),
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.home_outlined, //Direccion
                                  size: 30,
                                  color: Constants.WEDDING,
                                ),
                                VerticalDivider(
                                  color: Constants.WEDDING,
                                  thickness: 0.5,
                                  width: 25,
                                  indent: 9,
                                  endIndent: 4,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 1.0, top: 6.0, bottom: 6.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: size.width - 50,
                                            child: Text(
                                              pedido.comprador!.dir1!,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            ),
                                          ),
                                          SizedBox(
                                            width: size.width - 50,
                                            child: Text(
                                              pedido.comprador!.dir2!,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),

                    //Vendedor
                    Align(
                      alignment: Alignment(-0.9, 0.0),
                      child: Text(
                        "Vendedor",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Constants.WHITE,
                          border: Border.all(
                              width: 2.0,
                              color: Color.fromARGB(255, 226, 225, 225)),
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.account_circle_outlined, //Nombre
                                  size: 30,
                                  color: Constants.WEDDING,
                                ),
                                VerticalDivider(
                                  color: Constants.WEDDING,
                                  thickness: 0.5,
                                  width: 25,
                                  indent: 9,
                                  endIndent: 9,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    width: size.width - 200,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 1.0),
                                      child: Text(
                                        pedido.vendedor!.nombre!,
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async => await launch(
                                      "https://wa.me/593${pedido.vendedor!.phone!}?text=Hola! Soy ${name}, vengo a recoger el pedido ${pedido.numPedido!}. Le espero"),
                                  icon: Icon(
                                    Icons.messenger_outline,
                                    size: 30,
                                    color: Constants.WEDDING,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Constants.WEDDING,
                            thickness: 0.5,
                            height: 1,
                            endIndent: 50,
                          ),
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.language_outlined, //Ciudad
                                  size: 30,
                                  color: Constants.WEDDING,
                                ),
                                VerticalDivider(
                                  color: Constants.WEDDING,
                                  thickness: 0.5,
                                  width: 25,
                                  indent: 9,
                                  endIndent: 9,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 1.0),
                                    child: Text(
                                      pedido.vendedor!.ciudad!,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _makingPhoneCall(pedido.vendedor!.phone!);
                                  },
                                  icon: Icon(
                                    Icons.phone_outlined,
                                    size: 30,
                                    color: Constants.WEDDING,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            color: Constants.WEDDING,
                            thickness: 0.5,
                            height: 1,
                            endIndent: 50,
                          ),
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(
                                  Icons.home_outlined, //Direccion
                                  size: 30,
                                  color: Constants.WEDDING,
                                ),
                                VerticalDivider(
                                  color: Constants.WEDDING,
                                  thickness: 0.5,
                                  width: 25,
                                  indent: 9,
                                  endIndent: 9,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 1.0, top: 6.0, bottom: 6.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: size.width - 50,
                                          child: Text(
                                            pedido.vendedor!.calle1!,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.width - 50,
                                          child: Text(
                                            pedido.vendedor!.calle2!,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
                )
              ]),
            );
          }),
    );
  }
}
