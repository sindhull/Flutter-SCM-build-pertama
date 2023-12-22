import 'dart:convert';
import 'package:apk_sinduuu/screens/DetailScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:apk_sinduuu/screens/JammerScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../GlobalVar.dart';

class EditJammerPage extends StatefulWidget {
  final int id;
  final Map data;
  const EditJammerPage({Key? key, required this.id, required this.data}) : super(key: key);

  @override
  State<EditJammerPage> createState() => _EditJammerPageState();
}

class _EditJammerPageState extends State<EditJammerPage> {
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
          content: Text('Saving Changes'),
        ),
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();

      final Map<String, dynamic> data = {
        'nomor_seri': _serialNumberController.text,
        'ip_addr': _ipAddressController.text,
        'area_name': _areaNameController.text,
        'location': [_latitudeController.text, _longitudeController.text],
      };

      print(data);

      final Uri uri = Uri.parse("${baseUrl()}/dblockers/${widget.data['id']}"); // Ganti dengan API endpoint Anda
      // print("token: ${prefs.getString("access")!}");
      try {
        final response = await http.patch(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json',
            "Authorization" : prefs.getString("access")!
            // Add any other necessary headers
          },
          body: jsonEncode(data),
        );

        print(response.statusCode);
        print(response.request!.url);
        print(response.body);

        if (response.statusCode == 201) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JammerScreen(),
            ),
          );
        } else {
          // Handle other status codes or errors
          print('Failed to save changes. Status code: ${response.statusCode}');
        }
      } catch (error) {
        // Handle errors
        print('Error: $error');
      }
    }
  }

  @override
  void initState() {
    setState(() {
      _serialNumberController.text = widget.data['no_seri'];
      _ipAddressController.text = widget.data['ip_addr'];
      _areaNameController.text = widget.data['area_name'];
      _latitudeController.text = widget.data['latitude'];
      _longitudeController.text = widget.data['longitude'];
    });
    super.initState();
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
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => DetailPage(id: widget.id),
                ),
              );
            },
          ),
          title: Text(
            "Edit Jammer",
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
                    return 'Please enter Area name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  label: Text('Area name'),
                  hintText: 'Enter Area name',
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

              ElevatedButton(
                onPressed: _saveChanges,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen), // Set background color
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.025,
                      horizontal: MediaQuery.of(context).size.width * 0.1,
                    ),
                  ),
                  minimumSize: MaterialStateProperty.all<Size>(
                    Size(MediaQuery.of(context).size.width * 0.7, 50),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: Text('Simpan'),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
