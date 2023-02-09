import 'package:flutter/material.dart';
import 'package:prowess_app/utils/constants.dart' as Constants;

// ignore: must_be_immutable
class ButtonComponent extends StatelessWidget {
  Function()? onPressed;
  double? width;
  String text;

  ButtonComponent({Key? key, this.onPressed, this.width, this.text = "Button"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return MaterialButton(
          color: Constants.VINTAGE,
          disabledColor: Constants.VINTAGE,
          elevation: Constants.ELEVATION,
          onPressed: this.onPressed,
          child: Container(
            width: this.width,
            padding: EdgeInsets.symmetric(vertical: 15),
            alignment: Alignment.center,
            child: Text(
              this.text,
              style: TextStyle(
                  color: Constants.WHITE,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constants.BORDER_RADIOUS)),
        );
      },
    );
  }
}
