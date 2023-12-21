import 'dart:convert';

import 'package:apk_sinduuu/GlobalVar.dart';
import 'package:apk_sinduuu/screens/MainPage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'MyProfile.dart';

class ProfileSetting extends StatefulWidget {
  final Map data;
  const ProfileSetting({Key? key, required this.data}) : super(key: key);

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}



class _ProfileSettingState extends State<ProfileSetting> {
  TextEditingController _name = TextEditingController();
  TextEditingController _role = TextEditingController();

  @override
  void initState() {
    setState(() {
      _name.text = widget.data['nama'];
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => MainPage(index: 2,),
          ),
        );
        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => MainPage(index: 2,),
                  ),
                );
              },
            ),
            title: Text(
                "Edit Profile",
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
        body: Container(
          padding: EdgeInsets.only(left: 16, top: 25, right: 16),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 10),
                            ),
                          ],
                          shape: BoxShape.circle,
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/sindu.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: Colors.green,
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                buildTextField("Full Name",_name),
                SizedBox(
                  height: 10,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.44), //
                ElevatedButton(
                  onPressed: ()async{

                    print(_name.text);

                    SharedPreferences prefs = await SharedPreferences.getInstance();

                    var response = await http.patch(Uri.parse("${baseUrl()}/users/update/${widget.data['id']}"), headers: {
                      "Authorization": prefs.getString("access")!,
                      "Content-type": "application/json"
                    },
                        body: json.encode({
                          "nama" : _name.text,
                        }));

                    if (kDebugMode) {
                      print(response.statusCode);
                      print(response.request!.url);
                      print(response.body);
                    }

                    if(response.statusCode == 201){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Akun berhasil diubah'),
                        ),
                      );

                      // Navigasi ke halaman lain di sini setelah validasi berhasil
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainPage(index: 2), // Ganti dengan halaman tujuan yang diinginkan
                        ),
                      );
                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(json.decode(response.body)['message']),
                        ),
                      );
                    }


                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.0008,
                      horizontal: MediaQuery.of(context).size.width * 0.0008,
                    ),
                    minimumSize: Size(
                      MediaQuery.of(context).size.width * 0.7,
                      50,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.lightGreen,
                  ),
                  child: Text('Edit'),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 3),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }
}
