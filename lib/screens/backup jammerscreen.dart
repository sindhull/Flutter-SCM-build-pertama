import 'dart:convert';

import 'package:apk_sinduuu/screens/AddJammer.dart';
import 'package:apk_sinduuu/screens/DetailScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../GlobalVar.dart';
import '../utils/card.dart';
import 'package:http/http.dart' as http;

class JammerScreen extends StatefulWidget {
  const JammerScreen({Key? key}) : super(key: key);

  @override
  State<JammerScreen> createState() => _JammerScreenState();
}

class _JammerScreenState extends State<JammerScreen> {
  bool fetching = false;
  List _jammer = [];

  getListJammer()async{
    setState(() {
      fetching = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance(); //get data from shared preferences (penyimpanan sementara hp)

    var response = await http.get(Uri.parse("${baseUrl()}/api/dblockers"),headers: {
      "Authorization" : prefs.getString("access")!
    });

    if (kDebugMode) {
      print(response.statusCode);
      print(response.request!.url);
      print(response.body);
    }

    if(response.statusCode == 200){
      setState(() {
        _jammer = json.decode(response.body)['data']['dblockers'];
      });
    }else{
      warning(context, json.decode(response.body)['message']);
    }

    setState(() {
      fetching = false;
    });
  }

  @override
  void initState() {
    getListJammer();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: Container(
          padding: EdgeInsets.all(25),
          color: Colors.grey[100],
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Static Drone Blocker',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddJammerPage(),
                          ),
                        );
                      },
                      child: Icon(Icons.add),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Listview of exercises
                Expanded(
                    child: _jammer.isEmpty ? Center(
                      child: Text("Belum ada jammer"),
                    ) : ListView.builder(
                        itemCount: _jammer.length,
                        itemBuilder: (context, index){
                          // return _buildJammerCard(context, "test", "on", "off", 1);
                          return _buildJammerCard(
                            context,
                            _jammer[index]['no_seri'],
                            _jammer[index]['jammer_rc'] ?? "OFF",
                            _jammer[index]['jammer_gps'] ?? "OFF",
                            _jammer[index]['id'],
                          );
                        })
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJammerCard(BuildContext context, String cardName,String rc, String gps, int id) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(id: id,),
            ),
          );
        },
        child: Container(
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
                    Icon(Icons.settings_input_antenna, color: Colors.white),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width*0.02,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cardName,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height*0.01,
                        ),
                        Row(
                          children: [
                            Text('RC: ${rc} | '),
                            Text('GPS: ${gps}'),
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

                            var response = await http.post(Uri.parse("${baseUrl()}/api/dblockers/${id}"),headers: {
                              "Authorization" : prefs.getString("access")!
                            },body: {
                              "user_id": prefs.getString("userId"),
                              "dblocker_id": id,
                              "jammer_rc": rc == "on" ? "off" : "on",
                              "jammer_gps": gps == "on" ? "on" : "off"
                            });

                            if (kDebugMode) {
                              print(response.statusCode);
                              print(response.request!.url);
                              print(response.body);
                            }

                            if(response.statusCode == 200){
                              setState(() {
                                _jammer = [];
                              });

                              getListJammer();
                            }else{
                              warning(context, json.decode(response.body)['message']);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.sizeOf(context).width*0.15,
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(bottom: MediaQuery.sizeOf(context).height*0.01),
                            decoration: BoxDecoration(
                                color: rc == "on" ? Colors.yellow : Colors.red,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Text(rc == "on" ? 'ON' : 'OFF',style: TextStyle(
                                color: rc == "on" ? Colors.black : Colors.white
                            ),),
                          ),
                        ),
                        GestureDetector(
                          onTap: ()async{
                            SharedPreferences prefs = await SharedPreferences.getInstance();

                            var response = await http.post(Uri.parse("${baseUrl()}/api/dblockers/${id}"),headers: {
                              "Authorization" : prefs.getString("access")!
                            },body: {
                              "user_id": prefs.getString("userId"),
                              "dblocker_id": id,
                              "jammer_rc": rc == "on" ? "on" : "off",
                              "jammer_gps": gps == "on" ? "off" : "on"
                            });

                            if (kDebugMode) {
                              print(response.statusCode);
                              print(response.request!.url);
                              print(response.body);
                            }

                            if(response.statusCode == 201){
                              setState(() {
                                _jammer = [];
                              });

                              getListJammer();
                            }else{
                              warning(context, json.decode(response.body)['message']);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.sizeOf(context).width*0.15,
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: gps == "on" ? Colors.yellow : Colors.red,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Text(gps == "on" ? 'ON' : 'OFF',style: TextStyle(
                                color: gps == "on" ? Colors.black : Colors.white
                            ),),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            )
        )

      // CardPage(
      //   icon: Icons.settings_input_antenna,
      //   cardName: cardName,
      //   statusRC: rc,
      //   statusGPS: gps,
      //   color: Colors.orange,
      //   id: id,
      // ),
    );
  }
}
