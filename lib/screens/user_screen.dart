// DIAMBIL BODY DARI TANGGAL AWAL KE TANGGAL AKHIR DAN DATANYA NANTI DIAMBIL DARI DATABASE
// NANTI BERARTI TINGGAL MEMBUAT TRIGGER DENGAN PACUAN DATA SESUAI TANGGAL


import 'dart:convert';

import 'package:apk_sinduuu/screens/DateLog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../GlobalVar.dart';
import '../utils/UserList.dart';
import 'package:http/http.dart' as http;

class UserPage extends StatefulWidget {
  const UserPage({Key? key, DateTimeRange? selectedDateRange});

  @override
  _LogPageState createState() => _LogPageState();
}

class _LogPageState extends State<UserPage> {
  bool _isLoading = true;
  List _log = [];

  DateTime date_from() {
    // Replace this logic with how you obtain the starting date
    // For example, returning a date 7 days ago from today:
    return DateTime.now().subtract(Duration(days: 7));
  }

  DateTime date_to() {
    // Replace this logic with how you obtain the ending date
    // For example, returning today's date:
    return DateTime.now();
  }

  String formattedDate(DateTime dateTime) {
    return DateFormat("yyyy-MM-dd").format(dateTime);
  }

  Future<void> getLog() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // var response = await http.get(
    //   Uri.parse("${baseUrl()}/dblockers/logs?from=${formattedDate(date_from())}&to=${formattedDate(date_to())}"),
    //   headers: {
    //     "Authorization": prefs.getString("access")!,
    //     "Content-type" : "application/json"
    //     // Sesuaikan header lain yang diperlukan untuk otorisasi
    //   },
    //
    // );

    Uri uri = Uri.parse("${baseUrl()}/dblockers/logs");
    final newUri = uri.replace(queryParameters: {
      'date_from': formattedDate(date_from()),
      'date_to': formattedDate(date_to()),
    });
    // print(newUri); //prints http://localhost:8080/country/find?name=uk
    final response = await http.get(newUri,
      headers: {
        "Authorization": prefs.getString("access")!,
        "Content-type" : "application/json"
        // Sesuaikan header lain yang diperlukan untuk otorisasi
      },
    );
    // final response = json.decode(getdata.body);
    print(response);
    if (kDebugMode) {
      print(response.statusCode);
      print(response.request!.url);
      print(response.body);
    }

    if (response.statusCode == 200) {
      setState(() {
        _log = json.decode(response.body)['data']['logs'];
      });
    } else {
      // Tangani error, misalnya menampilkan snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(json.decode(response.body)['message']),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }


  @override
  void initState() {
    getLog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => DatePage(),
                ),
              );
            },
          ),
          title: Text(
            "Catatan Aktivitas",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.lightGreen,
          automaticallyImplyLeading: false,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30), // Sesuaikan radius lengkung
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        child: Container(
          padding: EdgeInsets.all(25),
          color: Colors.white,
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 20),

                Expanded(
                  child: _isLoading
                      ? Center(
                    child: Lottie.asset(
                      'assets/animations/glass.json', // Ganti dengan lokasi file JSON animasi Anda
                      width: 560,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  )
                      : ListView.builder(
                    itemCount: _log.length,
                    itemBuilder: (context, index) {
                      return CardPage(
                        id: _log[index]['id'],
                        timestamp: _log[index]['timestamp'],
                        userid: _log[index]['users_id'],
                        nama: _log[index]['nama_user'],
                        jammerid: _log[index]['dblocker_id'],
                        areaname: _log[index]['area_name'],
                        rcstate: _log[index]['rc_state'],
                        gpsstate: _log[index]['gps_state'],
                        // temp: _log[index]['temp'],
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
}
