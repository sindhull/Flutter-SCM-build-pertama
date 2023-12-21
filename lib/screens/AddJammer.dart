import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:apk_sinduuu/screens/JammerScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../GlobalVar.dart';

class AddJammerPage extends StatefulWidget {
  const AddJammerPage({Key? key}) : super(key: key);

  @override
  State<AddJammerPage> createState() => _AddJammerPageState();
}

class _AddJammerPageState extends State<AddJammerPage> {
  final _formAddJammerKey = GlobalKey<FormState>();
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _ipAddressController = TextEditingController();
  final TextEditingController _areaNameController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  Future<void> _saveChanges() async {
    if (_formAddJammerKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Jammer Berhasil Ditambahkan...'),
        ),
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();

      final Map<String, dynamic> data = {
        'nomor_seri': _serialNumberController.text,
        'ip_addr': _ipAddressController.text,
        'area_name': _areaNameController.text,
        'location': [_latitudeController.text, _longitudeController.text]
      };

      final Uri uri = Uri.parse("${baseUrl()}/dblockers"); // Ganti dengan API endpoint Anda

      try {
        final response = await http.post(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Authorization": prefs.getString("access")!
            // Add any other necessary headers
          },
          body: jsonEncode(data),
        );

        if (response.statusCode == 201) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JammerScreen(),
            ),
          );
        } else {
          // Handle other status codes or errors
          print('Gagal menambah jammer. Status code: ${response.statusCode}');
        }
      } catch (error) {
        // Handle errors
        print('Error: $error');
      }
    }
  }

  @override
  void dispose() {
    _serialNumberController.dispose();
    _ipAddressController.dispose();
    _areaNameController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          title: Text(
            'Tambah Jammer',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formAddJammerKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40.0),
              SizedBox(height: 25.0),
              TextFormField(
                controller: _serialNumberController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter No. Seri';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  label: Text('Nomor Seri'),
                  hintText: 'Enter No. Seri',
                  hintStyle: TextStyle(
                    color: Colors.black26,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 25.0),
              TextFormField(
                controller: _ipAddressController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter IP Address';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  label: Text('IP Address'),
                  hintText: 'Enter IP Address',
                  hintStyle: TextStyle(
                    color: Colors.black26,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 25.0),
              TextFormField(
                controller: _areaNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Area Name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  label: Text('Area Name'),
                  hintText: 'Enter Area Name',
                  hintStyle: TextStyle(
                    color: Colors.black26,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 25.0),
              TextFormField(
                controller: _latitudeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Latitude';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  label: Text('Latitude'),
                  hintText: 'Enter Latitude',
                  hintStyle: TextStyle(
                    color: Colors.black26,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 25.0),
              TextFormField(
                controller: _longitudeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Longitude';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  label: Text('Longitude'),
                  hintText: 'Enter Longitude',
                  hintStyle: TextStyle(
                    color: Colors.black26,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 25.0),
              SizedBox(height: 50.0),
              SizedBox(height: 30.0),
              SizedBox(height: 30.0),
              SizedBox(height: 30.0),
              Container(
                margin: EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton(
                  onPressed: _saveChanges,
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
                  child: Text('Tambah'),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
