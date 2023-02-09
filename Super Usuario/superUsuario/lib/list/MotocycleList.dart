import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prowess_app/widgets/Search.dart';
import 'package:prowess_app/utils/constants.dart' as Constants;

class MotocycleList extends StatefulWidget {
  const MotocycleList({Key? key, required this.admin}) : super(key: key);
  final bool admin;
  @override
  _MotocycleListState createState() => _MotocycleListState();
}

class _MotocycleListState extends State<MotocycleList> {
  final textController = TextEditingController();
  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> motocycle;
    if (widget.admin) {
      motocycle = FirebaseFirestore.instance
          .collection("usuario")
          .where("Rol", isEqualTo: "Motorizado")
          .snapshots();
    } else {
      motocycle = FirebaseFirestore.instance
          .collection('preregistro_motocycle')
          .snapshots();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.VINTAGE,
        iconTheme: IconThemeData(
          color: Constants.WHITE,
        ),
        title: Text(
          (widget.admin) ? "Motorizados registrados" : "Control de aspirantes",
          style: TextStyle(
            color: Constants.WHITE,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: SearchFeed(
        admin: widget.admin,
      ),
    );
  }
}
