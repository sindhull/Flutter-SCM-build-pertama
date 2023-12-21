import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

String baseUrl(){
  // String dev = "http://localhost:5001/api";
  String dev = "https://scmdev.cloud/api";
  return dev;
}

Widget marker(){
  Widget _lottie = Lottie.asset("assets/icons/marker.png",width: 100,height: 100);
  return _lottie;
}

Widget radius(){
  Widget _lottie = Lottie.asset("assets/animations/radius.json",width: 1000,height: 1000);
  return _lottie;
}

warning(BuildContext context, String message){
  Dialogs.materialDialog(
      color: Colors.white,
      msg: message,
      msgAlign: TextAlign.center,
      lottieBuilder: Lottie.asset("assets/animations/warning.json"),
      context: context,
      actions: [
        IconsButton(
          onPressed: (){
            Navigator.pop(context);
          },
          text: 'OK',
        )
      ]
  );
}