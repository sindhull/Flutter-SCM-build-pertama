import 'package:apk_sinduuu/GlobalVar.dart';
import 'package:apk_sinduuu/screens/MainPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apk_sinduuu/widgets/custom_scaffold.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../theme/theme.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  final _formSignInKey = GlobalKey<FormState>();
  bool rememberPassword = true;

  bool hide = true;

  addAccess(String token, int id)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("access", token);
    prefs.setInt("userId", id);
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString("access") != null) {
      // Token masih ada, arahkan pengguna ke MainPage
      Get.off(() => const MainPage(index: 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Selamat Datang!',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.lightGreen,
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      TextFormField(
                        controller: _username,
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
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      TextFormField(
                        controller: _password,
                        obscureText: hide,
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          suffixIcon: GestureDetector(
                              onTap: (){
                                if(hide){
                                  setState(() {
                                    hide = false;
                                  });
                                }else{
                                  setState(() {
                                    hide = false;
                                  });
                                }
                              },
                              child: Icon(Icons.remove_red_eye,color: hide ? Colors.grey : CupertinoColors.systemBlue,)),
                          label: const Text('Password'),
                          hintText: 'Enter Password',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black12, // Default border color
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: ()async{
                            // Get.to(()=> const MainPage(index: 0));
                            if(_username.text.isEmpty && _username.text == ""){
                              warning(context, "Username tidak boleh kosong");
                            }else if(_password.text.isEmpty && _password.text == ""){
                              warning(context, "Password tidak boleh kosong");
                            }else{
                              var response = await http.post(Uri.parse("${baseUrl()}/users/login"), headers: {
                                "Content-type" : 'application/json'
                              },
                              body: json.encode({
                                "username" : _username.text,
                                "password" : _password.text
                              }));

                              if (kDebugMode) {
                                print(response.statusCode);
                                print(response.request!.url);
                                print(response.body);
                              }

                              print(response.body);

                              if(response.statusCode == 200){
                                addAccess("Bearer ${json.decode(response.body)['data']['token']}",json.decode(response.body)['data']['user_id']);
                                Get.to(()=> const MainPage(index: 0));
                              }else{
                                warning(context, json.decode(response.body)['message']);
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.lightGreen, // Ubah warna tombol ke warna light green
                            padding: EdgeInsets.symmetric(
                              vertical: MediaQuery.of(context).size.height * 0.025,
                              horizontal: MediaQuery.of(context).size.width * 0.1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text('Masuk'),
                        ),
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      const SizedBox(
                        height: 25.0,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
