import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'MainPage.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          title: Text(
            'About',
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
                  builder: (BuildContext context) => MainPage(index: 2,),
                ),
              );
            },
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 50),
                Container(
                  child: Column(
                    children: [
                      Lottie.asset('assets/animations/antidrone.json'), // Ganti dengan lokasi file JSON Anda
                      SizedBox(height: 10), // Jarak antara animasi dan teks
                      Text(
                        'Skyward Lockdown',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.7), // Memberikan efek transparan pada teks
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 15,),
                      Text(
                        'Version 1.0.0',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.3), // Memberikan efek transparan pada teks
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
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