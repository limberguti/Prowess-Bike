import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:prowess_app/models/pedidoModel.dart';

class PedidosService {
  PedidosService();

  Stream<QuerySnapshot> getPedidosLibres() {
    return FirebaseFirestore.instance
        .collection('pedidos')
        .where(
          "estado",
          whereIn: ["libre"],
        )
        .where("fecha",
            isGreaterThanOrEqualTo: DateTime(DateTime.now().year,
                DateTime.now().month, DateTime.now().day, 0, 0))
        .orderBy("fecha", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getPedidosTotal() {
    return FirebaseFirestore.instance
        .collection('pedidos')
        .where(
          "estado",
          whereIn: ["recogido", "en proceso", "en ruta"],
        )
        .where("fecha",
            isNotEqualTo: DateTime(DateTime.now().year,
                DateTime.now().month, DateTime.now().day, 0, 0))
        .orderBy("fecha", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getPedidosPendientes() {
    return FirebaseFirestore.instance
        .collection('pedidos')
        .where(
          "estado",
          whereIn: ["libre"],
        )
        .where("fecha",
            isNotEqualTo: DateTime(DateTime.now().year,
                DateTime.now().month, DateTime.now().day, 0, 0))
        .orderBy("fecha", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getPedidosAnteriores() {
    return FirebaseFirestore.instance
        .collection('pedidos')
        .where(
          "estado",
          whereIn: ["libre", "recogido", "en proceso", "en ruta"],
        )
        .where("fecha",
            isLessThan: DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day, 0, 0))
        .orderBy("fecha", descending: true)
        .snapshots();
  }

  Future<List<Pedido>> getPedidos(String document) async {
    List<Pedido> result = [];
    try {
      Map<String, dynamic> user = (await FirebaseFirestore.instance
              .collection("pedidos")
              .doc(document)
              .get())
          .data() as Map<String, dynamic>;
      dynamic pedidos = user["pedidos"];
      print("Llego a service pedido");
      for (var item in pedidos) {
        final pedido = Pedido.fromJson(item);
        print(pedido);
        result.add(pedido);
      }
      return result;
    } catch (ex) {
      return result;
    }
  }

  updatePedidos(String document, String estado) async {
    /* OrdersMoto service = OrdersMoto();
      service.getPackages(document).then((value) {
      _orden.add(value[0]);
      if (mounted) {
        setState(() {});
      }
    });*/
    try {
      await FirebaseFirestore.instance
          .collection('pedidos')
          .doc(document)
          .update({'estado': estado});
    } catch (e) {
      print(e);
    }
  }

  acceptPedidos(String document, String estado, String uid_mot) async {
    /* OrdersMoto service = OrdersMoto();
      service.getPackages(document).then((value) {
      _orden.add(value[0]);
      if (mounted) {
        setState(() {});
      }
    });*/
    try {
      await FirebaseFirestore.instance
          .collection('pedidos')
          .doc(document)
          .update({'estado': estado, 'uid_mot': uid_mot});
    } catch (e) {
      print(e);
    }
  }

  Future<bool> comprobarPedido(String pedidoId) async {
    var _pedidoSn = await FirebaseFirestore.instance
        .collection('pedidos')
        .doc(pedidoId)
        .get();
    if (_pedidoSn.get("estado") == "libre") {
      return true;
    }
    return false;
  }
}
