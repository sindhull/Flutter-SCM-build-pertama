import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../GlobalVar.dart';

class EditUserPage extends StatefulWidget {
  final int userID; // ID pengguna yang akan diperbarui
  const EditUserPage({Key? key, required this.userID}) : super(key: key);

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final GlobalKey<FormState> _formEditUserKey = GlobalKey<FormState>();
  String? _username;
  String? _password;
  String? _jabatan;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit User',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.yellow, // Background color of the app bar
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formEditUserKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40.0),
              const SizedBox(height: 25.0),
              // Username
              TextFormField(
                onChanged: (value) {
                  _username = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Username';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  label: const Text('Username'),
                  hintText: 'Enter Username',
                  hintStyle: const TextStyle(
                    color: Colors.black26,
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 25.0),
              // Password
              TextFormField(
                onChanged: (value) {
                  _password = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  label: const Text('Password'),
                  hintText: 'Enter Password',
                  hintStyle: const TextStyle(
                    color: Colors.black26,
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 25.0),
              // Jabatan
              TextFormField(
                onChanged: (value) {
                  _jabatan = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Jabatan';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  label: const Text('Jabatan'),
                  hintText: 'Enter Jabatan',
                  hintStyle: const TextStyle(
                    color: Colors.black26,
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Colors.black12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 50.0),
              // Save Changes button
              ElevatedButton(
                onPressed: () async {
                  if (_formEditUserKey.currentState!.validate()) {
                    var url = Uri.parse("${baseUrl()}/api/users/update/${widget.userID}");

                    var data = jsonEncode({
                      'username': _username,
                      'password': _password,
                      'jabatan': _jabatan,
                    });

                    var response = await http.patch(
                      url,
                      headers: <String, String>{
                        'Content-Type': 'application/json; charset=UTF-8',
                        // Tambahkan header lain jika diperlukan (misalnya token)
                      },

                      body: data,
                    );

                    if (response.statusCode == 200) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Changes Saved Successfully'),
                        ),
                      );

                      Navigator.pop(context); // Kembali ke halaman sebelumnya
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to Save Changes'),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    vertical: MediaQuery.of(context).size.height * 0.025,
                    horizontal: MediaQuery.of(context).size.width * 0.1,
                  ),
                  minimumSize: Size(
                    MediaQuery.of(context).size.width * 0.7,
                    50,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Save Changes'),
              ),
              const SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }
}
