import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prowess_app/models/pedidoModel.dart';

class DetalleCard extends StatelessWidget {
  const DetalleCard({Key? key, required this.model}) : super(key: key);
  final Detalle model;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: Container(
        padding: EdgeInsets.all(18.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50.0),
            border: Border.all(width: 2.0, color: Colors.white)),
        width: size.width - 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width - 150,
                  child: Text(model.nombre!,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal)),
                ),
                Text("x" + model.cantidad.toString(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
