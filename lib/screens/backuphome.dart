// import 'package:apk_sinduuu/screens/DateLog.dart';
// import 'package:apk_sinduuu/screens/log.dart';
// import 'package:apk_sinduuu/screens/user_screen.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import '../GlobalVar.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({Key? key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   bool fetching = false;
//   Map _detail = {};
//
//   getDetailUser() async {
//     setState(() {
//       fetching = true;
//     });
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     var response = await http.get(Uri.parse("${baseUrl()}/users/current/${prefs.getInt("userId")}"), headers: {
//       "Authorization": prefs.getString("access")!
//     });
//
//     if (kDebugMode) {
//       print(response.statusCode);
//       print(response.request!.url);
//       print(response.body);
//     }
//
//     if (response.statusCode == 200) {
//       setState(() {
//         _detail = json.decode(response.body)['data'].first;
//       });
//
//       if(prefs.getString("username") == null){
//         prefs.setString("username", json.decode(response.body)['data'].first['username']);
//       }
//
//     } else {
//       warning(context, json.decode(response.body)['message']);
//     }
//
//     setState(() {
//       fetching = false;
//     });
//   }
//
//   @override
//   void initState() {
//     getDetailUser();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.yellow,
//         surfaceTintColor: Colors.yellow,
//         toolbarHeight: 70,
//         elevation: 0,
//         leading: Padding(
//           padding: EdgeInsets.only(left: 15.0),
//           child: Image.asset(
//             'assets/images/logosapta.png',
//           ),
//         ),
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(1.0), // Adjust the height of the line as needed
//           child: Container(
//             color: Colors.yellow, // Line color
//             height: 1.0, // Line height
//           ),
//         ),
//         actions: <Widget>[
//           IconButton(
//             icon: Icon(
//               Icons.notifications, // Ganti dengan ikon yang diinginkan
//               color: Colors.black, // Sesuaikan warna ikon jika perlu
//             ),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => DatePage(), // Ganti dengan halaman yang diinginkan
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: fetching
//           ? Center(
//         child: LottieBuilder.asset(
//           "assets/animations/loading.json",
//           width: 100,
//           height: 100,
//         ),
//       )
//           : SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.yellow,
//                 borderRadius: BorderRadius.only(
//                   bottomRight: Radius.circular(45.0),
//                   bottomLeft: Radius.circular(45.0),
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 40.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         Container(
//                           padding: EdgeInsets.only(bottom: 25.0),
//                           child: Row(
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.only(top: 10.0), // Atur posisi gambar kebawah
//                                 child: CircleAvatar(
//                                   backgroundImage: AssetImage('assets/images/sindu.png'),
//                                   backgroundColor: Colors.blue,
//                                   radius: 25,
//                                 ),
//                               ),
//                               SizedBox(width: 10), // Tambahkan spasi antara gambar dan teks
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Halo, ${_detail['nama'] ?? 'Pengguna'}!',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w500,
//                                       fontSize: 18,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                   SizedBox(height: 2),
//                                   Text(
//                                     'Selamat datang!',
//                                     style: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: 13,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         //... Bagian lain dari tampilan Anda
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 10,),
//                 ],
//               ),
//             ),
//             SizedBox(height: 25,),
//             Center(
//               child: Text(
//                 'Static Drone Blocker SP17',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             SizedBox(height: 35),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   'assets/images/static.jpg',
//                   width: MediaQuery.of(context).size.width * 0.8,
//                   height: 250,
//                   fit: BoxFit.fill,
//                 ),
//               ],
//             ),
//             SizedBox(height: 30),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Text(
//                 'SP17 merupakan static drone blocker yang diperuntukkan untuk lingkungan berbahaya tinggi, seperti lapangan peperangan, kawasan yang rawan bencana, atau lingkungan dengan hutan yang lebat. Blocker ini memiliki fitur cancelling system yang memungkinkan drone agak melambat dan terlihat mengalir melalui barrier. Fitur ini bertujuan untuk mengurangi tingkat kerugian dan potensi terjadinya insiden yang melibatkan drone dan operator yang melakukan uji drone di area yang berbahaya tinggi.'
//                     '\n\nSelain itu, SP17 juga dilengkapi dengan fitur system real-time monitoring. Operator dapat mengakses dan mengontrol blocker melalui antarmuka pengontrol yang telah diintegrasikan dengan sistem drone yang digunakan. Fitur ini sangat berguna untuk mengawasi dan mengendalikan kegiatan drone yang melanggar aturan lingkungan berbahaya tinggi.'
//                     '\n\nSecara keseluruhan, Static Drone Blocker SP17 merupakan solusi canggih yang sangat berguna untuk lingkungan yang rawan terhadap kegiatan drone. Blocker ini menjamin keselamatan dan kenyamanan bagi operator yang melakukan uji drone di area yang berbahaya tinggi.',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.black87,
//                 ),
//                 textAlign: TextAlign.justify,
//               ),
//             ),
//             SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }
// }
