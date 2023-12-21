import 'dart:convert';

import 'package:apk_sinduuu/Page/DetailDrone.dart';
import 'package:apk_sinduuu/screens/MainPage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../GlobalVar.dart';
import 'EditJammer.dart';
import 'JammerScreen.dart';

class DetailPage extends StatefulWidget {
  final int id;
  const DetailPage({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool fetching = false;
  Map _detail = {};

  Future<void> getDetailJammer() async {
    setState(() {
      fetching = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var response = await http.get(
      Uri.parse("${baseUrl()}/dblockers/${widget.id}"),
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
        _detail = json.decode(response.body)['data']['dblockers'].first;
      });
    } else {
      warning(context, json.decode(response.body)['message']);
    }

    setState(() {
      fetching = false;
    });
  }

  Future<void> _refreshData() async {
    await getDetailJammer();
  }

  @override
  void initState() {
    super.initState();
    getDetailJammer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          title: Text(
            'Detail Drone Blocker',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),

            // onPressed: () {
            //   // Melakukan operasi get.offAll() sebelum navigasi
            //   Get.offAll(JammerScreen());
            // },

            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JammerScreen(),
                ),
              );
            },
          ),
          backgroundColor: Colors.lightGreen, // Warna kuning pada app bar
          automaticallyImplyLeading: false,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(30), // Sesuaikan radius lengkung
            ),
          ),
          centerTitle: true, // Menempatkan judul di tengah
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.03),
                          spreadRadius: 10,
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.settings_input_antenna_sharp,
                                size: 22,
                                color: Colors.black,
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Text(
                                  "Jammer Control",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 35),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'IP Address  :',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                _detail['ip_addr'] ?? '',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 8), // Spasi ke bawah
                              Divider(),
                              Text(
                                'Status Jammer RC  :',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                _detail['jammer_rc'] ?? '',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 8), // Spasi ke bawah
                              Divider(),
                              Text(
                                'Status Jammer GPS  :',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                _detail['jammer_gps'] ?? '',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 8), // Spasi ke bawah
                              Divider(),
                              Text(
                                'Area name  :',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                _detail['area_name'] ?? '',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),SizedBox(height: 8), // Spasi ke bawah
                              Divider(),
                              Text(
                                'Temperature  :',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                _detail['temp'] ?? '',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 8), // Spasi ke bawah
                              Divider(),
                              Text(
                                'Location  :',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${_detail['latitude'] ?? ''}, ${_detail['longitude'] ?? ''}',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 8), // Spasi ke bawah
                              Divider(),
                              Text(
                                'Tanggal aktif  :',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                _detail['tgl_aktif'] ?? '',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 8), // Spasi ke bawah
                              Divider(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.03),
                          spreadRadius: 10,
                          blurRadius: 3,
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailDrone(data: _detail, id: widget.id,),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.0008,
                        horizontal: MediaQuery.of(context).size.width * 0.0008,
                      ),
                      minimumSize: Size(
                        MediaQuery.of(context).size.width * 0.5,
                        50,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.lightGreen,
                    ),
                    child: Text('Tampilkan Lokasi'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditJammerPage(id: _detail['id'], data: _detail,), // Ganti EditJammerPage dengan halaman yang sesuai dan sertakan ID jammer yang dipilih
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.0008,
                        horizontal: MediaQuery.of(context).size.width * 0.0008,
                      ),
                      minimumSize: Size(
                        MediaQuery.of(context).size.width * 0.2,
                        50,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.lightGreen,
                    ),
                    child: Text('Edit'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: ()async{
                      SharedPreferences prefs = await SharedPreferences.getInstance();

                      var response = await http.delete(Uri.parse("${baseUrl()}/dblockers/${widget.id}"),headers: {
                        "Authorization" : prefs.getString("access")!
                      });

                      if (kDebugMode) {
                        print(response.statusCode);
                        print(response.request!.url);
                        print(response.body);
                      }

                      if(response.statusCode == 200){
                        Get.offAll(()=> MainPage(index: 1));
                      }else{
                        warning(context, json.decode(response.body)['message'].toString());
                      }

                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.0008,
                        horizontal: MediaQuery.of(context).size.width * 0.0008, // Mengatur nilai horizontal padding yang lebih kecil
                      ),
                      minimumSize: Size(
                        MediaQuery.of(context).size.width * 0.5, // Mengatur lebar minimum menjadi setengah lebar layar
                        50,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      // Mengatur warna latar belakang tombol Hapus menjadi merah
                      backgroundColor: Colors.lightGreen,
                    ),
                    child: Text('Hapus'),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
