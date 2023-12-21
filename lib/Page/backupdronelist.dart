import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../GlobalVar.dart';
import 'AddDrone.dart';
import 'AllDronePositions.dart';
import 'DetailDrone.dart';
import 'EditDrone.dart';


class DroneList extends StatefulWidget {
  const DroneList({super.key});

  @override
  State<DroneList> createState() => _DroneListState();
}

class _DroneListState extends State<DroneList> {
  List _drone = [];
  bool fetching = false;

  getDrone()async{
    setState(() {
      fetching = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var response = await http.get(Uri.parse("${baseUrl()}/dblockers"),headers: {
      "Authorization" : prefs.getString("access")!
    });

    if (kDebugMode) {
      print(response.statusCode);
      print(response.request!.url);
      print(response.body);
    }

    if(response.statusCode == 200){
      setState(() {
        _drone = json.decode(response.body)['data']['dblockers'];
      });
    }else{
      print(json.decode(response.body)['message'].toString());
    }
    setState(() {
      fetching = false;
    });
  }

  @override
  void initState() {
    getDrone();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Drone List"),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: (){
              Get.offAll(()=> AddDrone());
            },
            child: Icon(Icons.add,size: 30,color: Colors.red,),
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width*0.02,
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: MediaQuery.sizeOf(context).width*0.8,
        child: FloatingActionButton(
          onPressed: fetching ? null : (){
            Get.offAll(()=> AllDronePositions(data: _drone));
          },child: Text("Lokasi Semua Drone"),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: fetching ? Center(
          child: LottieBuilder.asset("assets/animations/loading.json",width: 100,height: 100,),
        ) : ListView.builder(
            padding: EdgeInsets.only(bottom: MediaQuery.sizeOf(context).height*0.1),
            itemCount: _drone.length,
            itemBuilder: (context, index){
              return GestureDetector(
                onTap: (){
                  Get.offAll(()=> DetailDrone(data: _drone[index], id: _drone[index]['id'],));
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.only(bottom: MediaQuery.sizeOf(context).height*0.01),
                  decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text((_drone[index]['no_seri'] ?? "").toString(),style: TextStyle(
                              color: Colors.white
                          ),),
                          Text((_drone[index]['latitude'] ?? "").toString(),style: TextStyle(
                              color: Colors.white
                          ),),
                          Text((_drone[index]['longitude'] ?? "").toString(),style: TextStyle(
                              color: Colors.white
                          )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                              onTap: (){
                                Get.offAll(()=> EditDrone(data: _drone[index]));
                              },
                              child: Icon(Icons.edit,size: 30,color: Colors.white,)),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width*0.02,
                          ),
                          GestureDetector(
                              onTap: ()async{
                                Dialogs.materialDialog(
                                  color: Colors.white,
                                  msg: "Memuat",
                                  msgAlign: TextAlign.center,
                                  lottieBuilder: Lottie.asset("assets/animations/loading.json"),
                                  context: context,
                                );
                                var response = await http.delete(Uri.parse("${baseUrl()}user/${_drone[index]['id']}"));

                                if (kDebugMode) {
                                  print(response.statusCode);
                                  print(response.request!.url);
                                  print(response.body);
                                }

                                if(response.statusCode == 200){
                                  Dialogs.materialDialog(
                                      color: Colors.white,
                                      msg: "Berhasil menghapus drone",
                                      msgAlign: TextAlign.center,
                                      lottieBuilder: Lottie.asset("assets/animations/success.json"),
                                      context: context,
                                      actions: [
                                        IconsButton(
                                          onPressed: (){
                                            Get.back();
                                            Get.back();
                                          },
                                          text: 'OK',
                                        )
                                      ]
                                  );
                                  setState(() {
                                    _drone = [];
                                  });

                                  await getDrone();

                                }else{
                                  warning(json.decode(response.body)['message']);
                                }
                              },
                              child: Icon(Icons.delete,size: 30,color: Colors.red,))
                        ],
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
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
              Navigator.of(context).pop();
            },
            text: 'OK',
          )
        ]
    );
  }

}
