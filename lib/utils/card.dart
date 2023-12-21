import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../GlobalVar.dart';

class CardPage extends StatefulWidget {
  final IconData icon;
  final String cardName;
  String statusRC;
  String statusGPS;
  final Color color;
  final int id;

  CardPage({
    required this.icon,
    required this.cardName,
    required this.statusRC,
    required this.statusGPS,
    required this.color, required this.id,
  });

  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {
  bool isRCOn = false;
  bool isGPSOn = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),// Gunakan MediaQuery untuk ketinggian
      margin: EdgeInsets.only(bottom: MediaQuery.sizeOf(context).height*0.01),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(widget.icon, color: Colors.white),
              SizedBox(
                width: MediaQuery.sizeOf(context).width*0.02,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.cardName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height*0.01,
                  ),
                  Row(
                    children: [
                      Text('RC: ${widget.statusRC} | '),
                      Text('GPS: ${widget.statusGPS}'),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              Column(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: ()async{
                        SharedPreferences prefs = await SharedPreferences.getInstance();

                        var response = await http.post(Uri.parse("${baseUrl()}/api/dblockers/${widget.id}"),headers: {
                        "Authorization" : prefs.getString("access")!
                        },body: {
                          "user_id": prefs.getString("userId"),
                          "dblocker_id": widget.id,
                          "jammer_rc": isRCOn ? "off" : "on",
                          "jammer_gps": isGPSOn ? "on" : "off"
                          });

                        if (kDebugMode) {
                          print(response.statusCode);
                          print(response.request!.url);
                          print(response.body);
                        }

                        if(response.statusCode == 201){
                          setState((){
                            isRCOn = !isRCOn;
                          });
                        }

                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.sizeOf(context).width*0.15,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(bottom: MediaQuery.sizeOf(context).height*0.01),
                        decoration: BoxDecoration(
                          color: isRCOn ? Colors.yellow : Colors.red,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Text(isRCOn ? 'ON' : 'OFF',style: TextStyle(
                          color: isRCOn ? Colors.black : Colors.white
                        ),),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isGPSOn = !isGPSOn;
                          widget.statusGPS = isGPSOn ? 'Online' : 'Offline';
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.sizeOf(context).width*0.15,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: isGPSOn ? Colors.yellow : Colors.red,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Text(isGPSOn ? 'ON' : 'OFF',style: TextStyle(
                          color: isGPSOn ? Colors.black : Colors.white
                        ),),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
      )
    );
  }
}

