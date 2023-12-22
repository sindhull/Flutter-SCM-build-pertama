import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../GlobalVar.dart';
import 'DateLog.dart';

class UserPage extends StatefulWidget {
  final DateTimeRange? selectedDateRange;

  const UserPage({Key? key, this.selectedDateRange}) : super(key: key);

  @override
  _LogPageState createState() => _LogPageState();
}

class _LogPageState extends State<UserPage> {
  bool _isLoading = true;
  List _log = [];

  DateTime date_from() {
    return widget.selectedDateRange?.start ?? DateTime.now();
  }

  DateTime date_to() {
    return widget.selectedDateRange?.end ?? DateTime.now();
  }

  String formattedDate(DateTime dateTime) {
    return DateFormat("yyyy-MM-dd").format(dateTime);
  }

  Future<void> getLog() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Uri uri = Uri.parse("${baseUrl()}/dblockers/logs");
    final newUri = uri.replace(queryParameters: {
      'date_from': formattedDate(date_from()),
      'date_to': formattedDate(date_to()),
    });

    final response = await http.get(newUri, headers: {
      "Authorization": prefs.getString("access")!,
      "Content-type": "application/json"
      // Sesuaikan header lain yang diperlukan untuk otorisasi
    });

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
              bottom: Radius.circular(30),
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
                Expanded(
                  child: _isLoading
                      ? Center(
                    child: Lottie.asset(
                      'assets/animations/glass.json',
                      width: 560,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  )
                      : _log.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/animations/notfound.json', // Perbaiki path menuju file 'notfound.json'
                          width: 200,
                          height: 200,
                        ),
                        Text(
                          'Aktivitas tidak ditemukan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                      : ListView.builder(
                    itemCount: _log.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text('${_log[index]['nama_user']}'),
                          subtitle: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text('ID: ${_log[index]['id']}'),
                              Text(
                                  'Tanggal: ${_log[index]['timestamp']}'),
                              Text(
                                  'User ID: ${_log[index]['users_id']}'),
                              Text(
                                  'Jammer ID: ${_log[index]['dblocker_id']}'),
                              Text(
                                  'Area Name: ${_log[index]['area_name']}'),
                              Text(
                                  'RC State: ${_log[index]['rc_state']}'),
                              Text(
                                  'GPS State: ${_log[index]['gps_state']}'),
                              Text(
                                  'Temperature: ${_log[index]['temp']}'),
                              // Tambahkan informasi lain yang diinginkan di sini
                            ],
                          ),
                        ),
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
