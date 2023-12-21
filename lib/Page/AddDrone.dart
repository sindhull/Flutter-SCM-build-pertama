import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';

import '../GlobalVar.dart';
import 'DroneList.dart';

class AddDrone extends StatefulWidget {
  const AddDrone({super.key});

  @override
  State<AddDrone> createState() => _AddDroneState();
}

class _AddDroneState extends State<AddDrone> {
  TextEditingController _latitude = TextEditingController();
  TextEditingController _longitude = TextEditingController();
  TextEditingController _SN = TextEditingController();

  Widget _tfield(TextEditingController controller, String label){
    return SizedBox(
      height: MediaQuery.sizeOf(context).height*0.06,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp(r'[a-zA-Z]')), // Exclude alphabetic characters
        ],
        decoration: InputDecoration(
          labelText: label,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15)
            )
        ),
      ),
    );
  }

  Widget _space(){
    return SizedBox(
      height: MediaQuery.sizeOf(context).height*0.01,
    );
  }

  warning(String message){
    return Dialogs.materialDialog(
        color: Colors.white,
        msg: message,
        msgAlign: TextAlign.center,
        lottieBuilder: Lottie.asset("assets/animations/warning.json"),
        context: context,
        actions: [
          IconsButton(
            onPressed: (){
              Get.back();
            },
            text: 'OK',
          )
        ]
    );
  }

  @override
  void initState() {
    setState(() {
      // _latitude.text.isNumericOnly;
      // _longitude.text.isNumericOnly;
      // _SN.text.isNumericOnly;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: (){
            Get.offAll(()=> DroneList());
          },
          child: Icon(Icons.arrow_back,size: 30,color: Colors.red,),
        ),
        title: Text("Tambah Drone"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _tfield(_SN, "Serial Number"),
              _space(),
              _tfield(_latitude, "Latitude"),
              _space(),
              _tfield(_longitude, "Longitude"),
              _space(),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: MediaQuery.sizeOf(context).width*0.7,
        height: MediaQuery.sizeOf(context).height*0.06,
        child: FloatingActionButton(
            onPressed: ()async{
              if(_latitude.text == "" && _latitude.text.isEmpty){
                warning("Latitude tidak boleh kosong");
              }else if(int.parse(_latitude.text) > 90 || int.parse(_latitude.text) < -90){
                warning("latitude salah");
              }else if(int.parse(_longitude.text) > 180 || int.parse(_longitude.text) < -180){
                warning("longitude salah");
              }else{
                Dialogs.materialDialog(
                    color: Colors.white,
                    msg: "Memuat",
                    msgAlign: TextAlign.center,
                    lottieBuilder: Lottie.asset("assets/animations/loading.json"),
                    context: context,
                );
                var response = await http.post(Uri.parse("${baseUrl()}register"),body: {
                  "name": _SN.text,
                  "email":"email",
                  "password":"password",
                  "latitude":_latitude.text,
                  "longitude":_longitude.text
                });

                if (kDebugMode) {
                  print(response.statusCode);
                  print(response.request!.url);
                  print(response.body);
                }

                if(response.statusCode == 201){
                  Dialogs.materialDialog(
                      color: Colors.white,
                      msg: "Berhasil membuat drone",
                      msgAlign: TextAlign.center,
                      lottieBuilder: Lottie.asset("assets/animations/success.json"),
                      context: context,
                      actions: [
                        IconsButton(
                          onPressed: (){
                            Get.offAll(()=> DroneList());
                          },
                          text: 'OK',
                        )
                      ]
                  );
                }else{
                  warning(json.decode(response.body)['message']);
                }
              }

            },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add,size: 30,),
            Text("Tambah Drone")
          ],
        ),),
      ),
    );
  }
}
