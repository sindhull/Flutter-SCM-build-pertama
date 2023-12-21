// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../GlobalVar.dart';
// import '../Page/AllDronePositions.dart';
// import '../utils/card.dart';
// import 'package:apk_sinduuu/screens/DetailScreen.dart';
// import 'AddJammer.dart';
//
// class LogCardPage extends StatefulWidget {
//   const LogCardPage({Key? key}) : super(key: key);
//
//   @override
//   State<LogCardPage> createState() => _LogCardPageState();
// }
//
// class _LogCardPageState extends State<LogCardPage> {
//   List<dynamic> _log = [];
//   bool _fetching = true;
//
//   @override
//   void initState() {
//     _fetchLogs();
//     super.initState();
//   }
//
//   Future<void> _fetchLogs() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//
//     var response = await http.get(
//       Uri.parse("https://scmdev.cloud/api/dblcokers/logs"),
//       headers: {
//         "Authorization": prefs.getString("access")!,
//         "Content-Type": "application/json",
//       },
//     );
//
//     if (kDebugMode) {
//       print(response.statusCode);
//       print(response.request!.url);
//       print(response.body);
//     }
//
//     if (response.statusCode == 200) {
//       setState(() {
//         _log = json.decode(response.body);
//         _fetching = false;
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(json.decode(response.body)['message']),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(70.0),
//         child: AppBar(
//           title: Text(
//             'Log Activity',
//             style: TextStyle(
//               fontWeight: FontWeight.w700,
//               color: Colors.black,
//             ),
//           ),
//           backgroundColor: Colors.yellow,
//           automaticallyImplyLeading: false,
//           shape: ContinuousRectangleBorder(
//             borderRadius: BorderRadius.vertical(
//               bottom: Radius.circular(30), // Sesuaikan radius lengkung
//             ),
//           ),
//           centerTitle: true, // Menempatkan judul di tengah
//           actions: [
//             Padding(
//               padding: EdgeInsets.only(right: 16.0), // Ubah nilai sesuai dengan jarak yang diinginkan
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => AddJammerPage(), // Ganti dengan halaman yang diinginkan
//                     ),
//                   );
//                 },
//                 child: Icon(Icons.add),
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       floatingActionButton: SizedBox(
//         width: MediaQuery.sizeOf(context).width*0.8,
//         child: FloatingActionButton(
//           onPressed: fetching ? null : (){
//             Get.offAll(()=> AllDronePositions(data: _log));
//           },child: Text("Lihat Semua Lokasi Jammer"),),
//       ),
//       body: ClipRRect(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(25),
//           topRight: Radius.circular(25),
//         ),
//         child: Container(
//           padding: EdgeInsets.all(25),
//           color: Colors.grey[100],
//           child: Center(
//             child: Column(
//               children: [
//                 SizedBox(height: 20),
//                 Expanded(
//                   child: fetching
//                       ? Center(child: CircularProgressIndicator())
//                       : _log.isEmpty
//                       ? Center(
//                     child: Text("Belum ada jammer"),
//                   )
//                       : ListView.builder(
//                     itemCount: _log.length,
//                     itemBuilder: (context, index) {
//                       return _buildLogCard(
//                         context,
//                         _log[index]['id'],
//                         _log[index]['timestamp'],
//                         _log[index]['users_id'],
//                         _log[index]['nama_user'],
//                         _log[index]['dblocker_id'],
//                         _log[index]['area_name'],
//                         _log[index]['rc_state'],
//                         _log[index]['gps_state'],
//                         _log[index]['temp'],
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLogCard(
//       BuildContext context,
//       String id,
//       String timestamp,
//       String userId,
//       String username,
//       String dblockerId,
//       String areaName,
//       String rcState,
//       String gpsState,
//       String temp,
//       ) {
//   }
// }
