import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:apk_sinduuu/screens/DateLog.dart';
import 'package:apk_sinduuu/screens/about.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:http/http.dart' as http;
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../GlobalVar.dart';
import 'profile.dart';
import 'signin_screen.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({Key? key}) : super(key: key);

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  bool fetching = false;
  Map _detail = {};

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String? accessToken = ;

    print({
      "Authorization": prefs.getString("access")!,
      "Content-Type": "application/json"
    });

    try {
      var response = await http.delete(Uri.parse("${baseUrl()}/users/logout"), // Ganti URL dengan endpoint logout yang benar
        headers: {
          "Authorization": prefs.getString("access")!
        }
        );

      print(response.body);

      if (response.statusCode == 200) {
        // Berhasil logout, hapus data dari Shared Preferences atau lakukan tindakan sesuai kebutuhan
        prefs.clear();

        // Navigasi ke halaman sign-in setelah berhasil logout
        Get.offAll(() => SignInScreen());
      } else {
        // Penanganan ketika gagal logout
        print("Gagal logout. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Terjadi kesalahan: $error");
    }
  }

  getDetailUser() async {
    setState(() {
      fetching = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var response = await http.get(Uri.parse("${baseUrl()}/users/current/${prefs.getInt("userId")}"), headers: {
      "Authorization": prefs.getString("access")!
    });

    if (kDebugMode) {
      print(response.statusCode);
      print(response.request!.url);
      print(response.body);
    }

    if (response.statusCode == 200) {
      setState(() {
        _detail = json.decode(response.body)['data'].first;
      });
    } else {
      warning(context, json.decode(response.body)['message']);
    }

    setState(() {
      fetching = false;
    });
  }


  @override
  void initState() {
    getDetailUser();
    super.initState();
  }

  List attachment = [];
  final ImagePicker _picker = ImagePicker();
  String path = "";

  void setFileFromLocal(BuildContext context) async {
    Dialogs.materialDialog(
      barrierDismissible: false,
      color: Colors.white,
      msg: 'Memuat',
      msgAlign: TextAlign.center,
      lottieBuilder: LottieBuilder.asset("assets/animations/lodscreen.json", width: 100, height: 100),
      context: context,
    );

    final pickerImage = await _picker.pickMultiImage(imageQuality: 50);
    Get.back();

    for (int i = 0; i < pickerImage.length; i++) {
      Uint8List? bytes = await pickerImage[i].readAsBytes();
      setState(() {
        path = pickerImage[i].path;
      });
      double size = File(pickerImage[i].path).lengthSync() / (1024 * 1024);
      print("size : $size");
      if (size > 5) {
        Dialogs.materialDialog(
          color: Colors.white,
          msg: 'Ukuran file maksimal 5MB',
          msgAlign: TextAlign.center,
          lottieBuilder: LottieBuilder.asset("Assets/Animations/warning.json"),
          context: context,
          actions: [
            IconsButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  path = "";
                });
              },
              text: 'OK',
            )
          ],
        );
      } else {
        setState(() {
          attachment.clear();
          attachment.add(path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.lightGreen,
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
                      children: [
                        SizedBox(height: 15),
                        Column(
                          children: [
                            Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                path == ""
                                    ? Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: AssetImage("assets/images/sindu.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                )
                                    : CircleAvatar(
                                  backgroundImage: FileImage(File(attachment.first)),
                                  radius: 50,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setFileFromLocal(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: Icon(Icons.edit, size: 15),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Column(
                              children: [
                                Text(
                                  "${_detail['nama'] ?? 'Pengguna'}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildInfoColumn(
                                "Jabatan",
                                "${_detail['jabatan'] ?? 'Title'}"
                            ),
                            _buildDivider(),
                            _buildInfoColumn(
                                "ID Pengguna",
                                "${_detail['id'] ?? 'UserID'}"
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(height: 5),
                _buildCard("Detail Personal", "Ubah profil disini", Icons.person, Colors.lightGreen),
                SizedBox(height: 5),
                _buildCard("Catatan Aktivitas", "Lihat catatan aktivitas disini", Icons.my_library_books, Colors.lightGreen),
                SizedBox(height: 5),
                _buildCard("Tentang Aplikasi", "Lihat versi aplikasi disini", Icons.info_outline_rounded, Colors.lightGreen),
                SizedBox(height: 5),
                _buildCard("Keluar", "", Icons.logout_sharp, Colors.lightGreen),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String title, String value) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 0.5,
      height: 40,
      color: Colors.black.withOpacity(0.3),
    );
  }

  Widget _buildCard(String title, String subtitle, IconData icon, Color iconColor) {
    return GestureDetector(
      onTap: () {
        if (title == "Detail Personal") {
          Get.to(() => ProfileSetting(data: _detail,));
        } else if (title == "Catatan Aktivitas") {
          Get.to(() => DatePage());
        } else if (title == "Tentang Aplikasi") {
          Get.to(() => AboutScreen());
          // print("Wes kepencet $title");
        } else if (title == "Keluar") {
          logout(); // Panggil fungsi logout saat tombol logout ditekan
        }
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.03),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: iconColor.withOpacity(0.03),
              spreadRadius: 10,
              blurRadius: 3,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: iconColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Icon(
                        icon,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Visibility(
                        visible: subtitle == "" ? false : true,
                        child: Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black.withOpacity(0.5),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 30),
            ],
          ),
        ),
      ),
    );
  }
}
