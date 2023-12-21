import 'package:flutter/material.dart';
import 'MainPage.dart';
import 'MyProfile.dart';

class SecurityScreen extends StatefulWidget {
  const SecurityScreen({Key? key}) : super(key: key);

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => MainPage(index: 4,),
          ),
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: (){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MainPage(index: 3,),
                ),
              );
            },
            child: Icon(Icons.arrow_back),
          ),
          title: Text("Change Password"),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.only(top: MediaQuery.sizeOf(context).height*0.02),
          padding: EdgeInsets.all(15),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                buildTextField("Current password", "", true),
                buildTextField("New password", "", true),
                buildTextField("Re-type new password", "", true),
                SizedBox(
                  height: 35,
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password Changed'),
                      ),
                    );

                    // Navigasi ke halaman lain di sini setelah validasi berhasil
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyProfile(), // Ganti dengan halaman tujuan yang diinginkan
                      ),
                    );
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.025, // Ubah sesuai kebutuhan
                        horizontal: MediaQuery.of(context).size.width * 0.1, // Ubah sesuai kebutuhan
                      ),
                    ),
                    minimumSize: MaterialStateProperty.all<Size>(
                      Size(MediaQuery.of(context).size.width * 0.7, 50), // Ubah sesuai kebutuhan
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        obscureText: isPasswordTextField ? !showPassword : false,
        decoration: InputDecoration(
          suffixIcon: isPasswordTextField
              ? IconButton(
            onPressed: () {
              setState(() {
                showPassword = !showPassword;
              });
            },
            icon: Icon(
              showPassword ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
          )
              : null,
          contentPadding: EdgeInsets.only(bottom: 3),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
