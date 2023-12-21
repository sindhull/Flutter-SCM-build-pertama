import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../GlobalVar.dart';
import 'AllDronePositions.dart';
import '../utils/card.dart';
import 'package:apk_sinduuu/screens/DetailScreen.dart';
import '../screens/AddJammer.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool fetching = false;
  List _location = [];

  Future<void> getListJammer() async {
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
        _location = json.decode(response.body)['data']['dblockers'];
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
            'Drone Blocker Location',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.yellow,
          automaticallyImplyLeading: false,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30), // Sesuaikan radius lengkung
            ),
          ),
          centerTitle: true, // Menempatkan judul di tengah
        ),
      ),
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
                SizedBox(height: 20),
                Expanded(
                  child: fetching
                      ? Center(child: CircularProgressIndicator())
                      : _location.isEmpty
                      ? Center(
                    child: Text("Belum ada jammer"),
                  )
                      : ListView.builder(
                    itemCount: _location.length,
                    itemBuilder: (context, index) {
                      return _buildJammerLocationCard(
                        context,
                        _location[index]['no_seri'],
                        _location[index]['latitude'],
                        _location[index]['longitude'],
                        _location[index]['id'],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJammerLocationCard(
      BuildContext context,
      String cardName,
      String latitude,
      String longitude,
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
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), // Warna dan opasitas bayangan
              spreadRadius: 1, // Menyebar bayangan
              blurRadius: 1, // Kecerahan bayangan
              offset: Offset(0, 2), // Perpindahan bayangan di sumbu x dan y
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
                        Text('Latitude : ${latitude} '),
                      ],
                    ),
                    Row(
                      children: [
                        Text('Longitude : ${longitude}'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
