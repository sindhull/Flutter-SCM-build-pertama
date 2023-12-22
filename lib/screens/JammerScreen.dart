import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../GlobalVar.dart';
import '../Page/AllDronePositions.dart';
import 'package:apk_sinduuu/screens/DetailScreen.dart';
import 'AddJammer.dart';

class JammerScreen extends StatefulWidget {
  const JammerScreen({Key? key}) : super(key: key);

  @override
  State<JammerScreen> createState() => _JammerScreenState();
}

class _JammerScreenState extends State<JammerScreen> {
  bool fetching = false;
  List _jammer = [];

  Future<void> getListJammer() async {
    setState(() {
      fetching = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var response = await http.get(
      Uri.parse("${baseUrl()}/dblockers"),
      headers: {
        "Authorization": prefs.getString("access")!,
      },
    );

    if (kDebugMode) {
      print(response.statusCode);
      print(response.request!.url);
      print(response.body);
    }

    if (response.statusCode == 200) {
      setState(() {
        _jammer = json.decode(response.body)['data']['dblockers'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(json.decode(response.body)['message']),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      fetching = false;
    });
  }

  Future<void> _refreshData() async {
    setState(() {
      fetching = true;
    });

    await getListJammer();

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
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          title: Text(
            'Static Drone Blocker',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.lightGreen,
          automaticallyImplyLeading: false,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30),
            ),
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: GestureDetector(
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
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 20.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: FloatingActionButton(
            onPressed: fetching ? null : () {
              Get.offAll(() => AllDronePositions(data: _jammer));
            },
            backgroundColor: Colors.lightGreen,
            child: Text(
              "Lihat Semua Lokasi Jammer",
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ClipRRect(
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
                  SizedBox(height: 20),
                  Expanded(
                    child: fetching
                        ? Center(child: CircularProgressIndicator())
                        : _jammer.isEmpty
                        ? Center(
                      child: Text("Belum ada jammer"),
                    )
                        : ListView.builder(
                      itemCount: _jammer.length,
                      itemBuilder: (context, index) {
                        return _buildJammerCard(
                          context,
                          _jammer[index]['no_seri'],
                          _jammer[index]['jammer_rc'] ?? "OFF",
                          _jammer[index]['jammer_gps'] ?? "OFF",
                          _jammer[index]['id'],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJammerCard(
      BuildContext context,
      String cardName,
      String rc,
      String gps,
      int id,
      ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(id: id),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.01,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.settings_input_antenna, color: Colors.black),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cardName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
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
                  children: [
                    GestureDetector(
                      onTap: () async {
                        print(id);
                        SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                        var response = await http.post(
                          Uri.parse("${baseUrl()}/dblockers/$id"),
                          headers: {
                            "Authorization": prefs.getString("access")!,
                          },
                          body: {
                            "user_id": prefs.getInt("userId").toString(),
                            'username': prefs.getString("username")!,
                            "jammer_rc": rc == "on" ? "off" : "on",
                            "jammer_gps": gps == "on" ? "on" : "off",
                          },
                        );

                        if (kDebugMode) {
                          print(response.statusCode);
                          print(response.request!.url);
                          print(response.body);
                        }

                        if (response.statusCode == 200) {
                          setState(() {
                            _jammer = [];
                          });

                          getListJammer();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(json.decode(response.body)['message']),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.15,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.01),
                        decoration: BoxDecoration(
                          color: rc == "on" ? Colors.yellow : Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          rc == "on" ? 'ON' : 'OFF',
                          style: TextStyle(
                              color: rc == "on" ? Colors.black : Colors.white),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                        var response = await http.post(
                          Uri.parse("${baseUrl()}/dblockers/${id}"),
                          headers: {
                            "Authorization": prefs.getString("access")!,
                          },
                          body: {
                            "user_id": prefs.getString("userId")!,
                            "dblocker_id": id.toString(),
                            "jammer_rc": rc == "on" ? "on" : "off",
                            "jammer_gps": gps == "on" ? "off" : "on",
                          },
                        );

                        if (kDebugMode) {
                          print(response.statusCode);
                          print(response.request!.url);
                          print(response.body);
                        }

                        if (response.statusCode == 201) {
                          setState(() {
                            _jammer = [];
                          });

                          getListJammer();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                              Text(json.decode(response.body)['message']),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width * 0.15,
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: gps == "on" ? Colors.yellow : Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          gps == "on" ? 'ON' : 'OFF',
                          style: TextStyle(
                              color: gps == "on" ? Colors.black : Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
